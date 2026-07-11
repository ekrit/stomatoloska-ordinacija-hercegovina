using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using SOH.Model.Exceptions;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;
using AppointmentStatus = SOH.Services.Database.AppointmentStatus;

namespace SOH.Services.Services
{
    public class PaymentService : BaseCRUDService<PaymentResponse, PaymentSearchObject, Payment, PaymentUpsertRequest, PaymentUpsertRequest>, IPaymentService
    {
        private const string PayPalMethod = "PayPal";

        private readonly IPayPalGateway _payPal;
        private readonly IConfiguration _configuration;
        private readonly INotificationService _notifications;

        public PaymentService(SOHDbContext context, IMapper mapper, IPayPalGateway payPal, IConfiguration configuration, INotificationService notifications)
            : base(context, mapper)
        {
            _payPal = payPal;
            _configuration = configuration;
            _notifications = notifications;
        }

        protected override IQueryable<Payment> ApplyFilter(IQueryable<Payment> query, PaymentSearchObject search)
        {
            if (search.AppointmentId.HasValue)
            {
                query = query.Where(x => x.AppointmentId == search.AppointmentId.Value);
            }

            if (search.Status.HasValue)
            {
                var status = (PaymentStatus)(int)search.Status.Value;
                query = query.Where(x => x.Status == status);
            }

            if (!string.IsNullOrEmpty(search.Method))
            {
                query = query.Where(x => x.Method.Contains(search.Method));
            }

            return query;
        }

        public async Task<PaymentOrderCreateResponse> CreateOrderAsync(int appointmentId, int callerUserId, bool isAdmin, CancellationToken cancellationToken = default)
        {
            var appointment = await _context.Appointments
                .Include(a => a.Service)
                .FirstOrDefaultAsync(a => a.Id == appointmentId, cancellationToken)
                ?? throw new NotFoundException("Termin nije pronađen.");

            await EnsureCallerOwnsAppointmentAsync(appointment, callerUserId, isAdmin, cancellationToken);

            var amount = appointment.Service?.Price ?? 0m;
            if (amount <= 0m)
            {
                throw new BusinessException("Ova usluga nema definisanu cijenu; nema se šta platiti.");
            }

            var payment = await _context.Payments
                .FirstOrDefaultAsync(p => p.AppointmentId == appointmentId, cancellationToken);

            if (payment != null && payment.Status == PaymentStatus.Paid)
            {
                throw new BusinessException("Ovaj termin je već plaćen.");
            }

            if (payment == null)
            {
                payment = new Payment
                {
                    AppointmentId = appointmentId,
                    Method = PayPalMethod,
                    Status = PaymentStatus.Pending,
                    Amount = amount,
                    CreatedAt = DateTime.UtcNow,
                };
                _context.Payments.Add(payment);
            }
            else
            {
                payment.Amount = amount;
                payment.Method = PayPalMethod;
                payment.Status = PaymentStatus.Pending;
            }

            var returnUrl = _configuration["PAYPAL:RETURN_URL"] ?? "https://example.com/paypal/return";
            var cancelUrl = _configuration["PAYPAL:CANCEL_URL"] ?? "https://example.com/paypal/cancel";

            var order = await _payPal.CreateOrderAsync(amount, returnUrl, cancelUrl, cancellationToken);
            payment.PayPalOrderId = order.OrderId;

            await _context.SaveChangesAsync(cancellationToken);

            return new PaymentOrderCreateResponse
            {
                PaymentId = payment.Id,
                OrderId = order.OrderId,
                ApprovalUrl = order.ApprovalUrl,
                Amount = amount,
            };
        }

        public async Task<PaymentCaptureResponse> CaptureOrderAsync(int paymentId, int callerUserId, bool isAdmin, CancellationToken cancellationToken = default)
        {
            var payment = await _context.Payments
                .Include(p => p.Appointment)
                .FirstOrDefaultAsync(p => p.Id == paymentId, cancellationToken)
                ?? throw new NotFoundException("Uplata nije pronađena.");

            await EnsureCallerOwnsAppointmentAsync(payment.Appointment, callerUserId, isAdmin, cancellationToken);

            if (payment.Status == PaymentStatus.Paid)
            {
                return new PaymentCaptureResponse { IsPaid = true, PaymentId = payment.Id, TransactionRef = payment.TransactionRef };
            }

            if (string.IsNullOrWhiteSpace(payment.PayPalOrderId))
            {
                throw new BusinessException("Ne postoji PayPal narudžba za naplatu; prvo kreirajte narudžbu.");
            }

            var captureId = await _payPal.CaptureOrderAsync(payment.PayPalOrderId, cancellationToken);
            payment.Status = PaymentStatus.Paid;
            payment.TransactionRef = captureId;
            await _context.SaveChangesAsync(cancellationToken);

            await _notifications.NotifyPaymentCapturedAsync(
                payment.Appointment.PatientId, payment.AppointmentId, payment.Amount, cancellationToken);

            return new PaymentCaptureResponse { IsPaid = true, PaymentId = payment.Id, TransactionRef = captureId };
        }

        public async Task RefundAsync(int paymentId, int callerUserId, bool isAdmin, CancellationToken cancellationToken = default)
        {
            var payment = await _context.Payments
                .Include(p => p.Appointment)
                .FirstOrDefaultAsync(p => p.Id == paymentId, cancellationToken)
                ?? throw new NotFoundException("Uplata nije pronađena.");

            await EnsureCallerOwnsAppointmentAsync(payment.Appointment, callerUserId, isAdmin, cancellationToken);

            // Idempotent: a payment already refunded is a no-op rather than an error.
            if (payment.Status == PaymentStatus.Refunded)
            {
                return;
            }

            if (payment.Status != PaymentStatus.Paid)
            {
                throw new BusinessException("Samo plaćena uplata može biti refundirana.");
            }

            if (payment.Appointment.Status == AppointmentStatus.Completed)
            {
                throw new BusinessException("Završen termin se više ne može refundirati.");
            }

            if (string.IsNullOrWhiteSpace(payment.TransactionRef))
            {
                throw new BusinessException("Nedostaje PayPal referenca naplate; povrat nije moguć.");
            }

            await _payPal.RefundCaptureAsync(payment.TransactionRef, cancellationToken);

            payment.Status = PaymentStatus.Refunded;
            payment.Appointment.Status = AppointmentStatus.Cancelled;
            await _context.SaveChangesAsync(cancellationToken);

            await _notifications.NotifyPaymentRefundedAsync(
                payment.Appointment.PatientId, payment.AppointmentId, cancellationToken);
        }

        public async Task HandleWebhookAsync(string eventType, string? payPalOrderId, string? captureId, CancellationToken cancellationToken = default)
        {
            Payment? payment = null;
            if (!string.IsNullOrWhiteSpace(payPalOrderId))
            {
                payment = await _context.Payments
                    .Include(p => p.Appointment)
                    .FirstOrDefaultAsync(p => p.PayPalOrderId == payPalOrderId, cancellationToken);
            }
            if (payment == null && !string.IsNullOrWhiteSpace(captureId))
            {
                payment = await _context.Payments
                    .Include(p => p.Appointment)
                    .FirstOrDefaultAsync(p => p.TransactionRef == captureId, cancellationToken);
            }
            if (payment == null)
            {
                return;
            }

            switch (eventType)
            {
                case "PAYMENT.CAPTURE.COMPLETED":
                    if (payment.Status != PaymentStatus.Paid)
                    {
                        payment.Status = PaymentStatus.Paid;
                        if (!string.IsNullOrWhiteSpace(captureId))
                        {
                            payment.TransactionRef = captureId;
                        }
                        await _context.SaveChangesAsync(cancellationToken);
                        await _notifications.NotifyPaymentCapturedAsync(
                            payment.Appointment.PatientId, payment.AppointmentId, payment.Amount, cancellationToken);
                    }
                    break;

                case "PAYMENT.CAPTURE.REFUNDED":
                    if (payment.Status != PaymentStatus.Refunded)
                    {
                        payment.Status = PaymentStatus.Refunded;
                        payment.Appointment.Status = AppointmentStatus.Cancelled;
                        await _context.SaveChangesAsync(cancellationToken);
                        await _notifications.NotifyPaymentRefundedAsync(
                            payment.Appointment.PatientId, payment.AppointmentId, cancellationToken);
                    }
                    break;
            }
        }

        /// <summary>
        /// Patients may only touch payments for their own appointments. The
        /// Patient primary key is the UserId, so Appointment.PatientId already
        /// equals the JWT user id — no extra lookup needed.
        /// </summary>
        private Task EnsureCallerOwnsAppointmentAsync(Appointment appointment, int callerUserId, bool isAdmin, CancellationToken cancellationToken)
        {
            if (!isAdmin && appointment.PatientId != callerUserId)
            {
                throw new BusinessException("Možete platiti samo vlastite termine.");
            }
            return Task.CompletedTask;
        }
    }
}
