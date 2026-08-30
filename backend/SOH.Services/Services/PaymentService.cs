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

        /// <summary>
        /// Administrative create/update may not fabricate a settled payment.
        /// Paid state, the provider transaction reference and the PayPal order
        /// id are produced by the verified provider flow (capture or a
        /// signature-checked webhook) and are ignored here, so raw CRUD cannot
        /// mark a visit paid without money having moved.
        /// </summary>
        private static void StripProviderControlledFields(Payment entity)
        {
            entity.Status = entity.Status == PaymentStatus.Refunded
                ? PaymentStatus.Refunded
                : PaymentStatus.Pending;
            entity.TransactionRef = null;
            entity.PayPalOrderId = null;
            entity.PaidAt = null;
            entity.Currency = MoneyPolicy.BusinessCurrency;
            entity.ChargedAmount = null;
            entity.ChargedCurrency = null;
        }

        protected override Task BeforeInsert(Payment entity, PaymentUpsertRequest request)
        {
            StripProviderControlledFields(entity);
            entity.CreatedAt = DateTime.UtcNow;
            return Task.CompletedTask;
        }

        protected override Task BeforeUpdate(Payment entity, PaymentUpsertRequest request)
        {
            // A settled payment is closed to raw edits; refunds go through the
            // refund flow, which talks to PayPal before changing state.
            if (entity.Status == PaymentStatus.Paid)
            {
                throw new BusinessException(
                    "Plaćena uplata se ne može mijenjati kroz administratorski CRUD. Koristite povrat novca.");
            }

            // These are pinned on the *request*, not the entity: mapping runs
            // after this hook, so clearing the entity here would simply be
            // overwritten by the request values. Status and TransactionRef are
            // owned by the verified provider flow — an admin PUT must not be
            // able to declare a payment settled.
            request.Status = (SOH.Model.Enums.PaymentStatus)(int)entity.Status;
            request.TransactionRef = entity.TransactionRef;

            // The payment stays attached to the appointment it was created for.
            request.AppointmentId = entity.AppointmentId;
            return Task.CompletedTask;
        }

        // A payment belongs to the patient and the doctor of its appointment.
        // PaymentResponse carries the amount, status and PayPal references, so
        // a single-record read has to be owner-checked, not just the list.
        public async Task<RecordOwner?> GetOwnerAsync(int id, CancellationToken cancellationToken = default)
        {
            var owner = await _context.Payments
                .AsNoTracking()
                .Where(p => p.Id == id)
                .Select(p => new { p.Appointment.PatientId, p.Appointment.DoctorId })
                .FirstOrDefaultAsync(cancellationToken);

            return owner == null ? null : new RecordOwner(owner.PatientId, owner.DoctorId);
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

            // Paying is only meaningful once the doctor has accepted. Booking
            // used to open the payment screen straight after a Requested
            // appointment was created, so a patient could pay for a visit the
            // doctor then declined — leaving a Paid payment on a Declined
            // appointment with no flow to reconcile the two.
            if (appointment.Status != AppointmentStatus.Accepted)
            {
                throw new BusinessException(
                    "Termin se može platiti tek nakon što ga doktor prihvati.");
            }

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

            var chargedAmount = MoneyPolicy.ToProviderCurrency(amount);

            // An existing Pending payment is reused rather than re-created: the
            // old code overwrote PayPalOrderId on every attempt, orphaning the
            // previous PayPal order while its approval link stayed live.
            if (payment != null &&
                payment.Status == PaymentStatus.Pending &&
                !string.IsNullOrWhiteSpace(payment.PayPalOrderId) &&
                payment.Amount == amount)
            {
                // Ask PayPal for the order's current approval link rather than
                // reconstructing a checkout URL. A null answer means the order
                // is no longer approvable (expired or already acted on), and we
                // fall through to opening a fresh one on the same payment row.
                var existingApproval = await _payPal.GetApprovalUrlAsync(payment.PayPalOrderId!, cancellationToken);
                if (!string.IsNullOrWhiteSpace(existingApproval))
                {
                    return new PaymentOrderCreateResponse
                    {
                        PaymentId = payment.Id,
                        OrderId = payment.PayPalOrderId!,
                        ApprovalUrl = existingApproval!,
                        Amount = amount,
                        Currency = MoneyPolicy.BusinessCurrency,
                        ChargedAmount = payment.ChargedAmount ?? chargedAmount,
                        ChargedCurrency = MoneyPolicy.ProviderCurrency,
                    };
                }
            }

            if (payment == null)
            {
                payment = new Payment
                {
                    AppointmentId = appointmentId,
                    Method = PayPalMethod,
                    Status = PaymentStatus.Pending,
                    Amount = amount,
                    Currency = MoneyPolicy.BusinessCurrency,
                    CreatedAt = DateTime.UtcNow,
                };
                _context.Payments.Add(payment);
            }
            else
            {
                // Reached only when the price changed under a stale Pending
                // payment, or a previous attempt never got an order id.
                payment.Amount = amount;
                payment.Currency = MoneyPolicy.BusinessCurrency;
                payment.Method = PayPalMethod;
                payment.Status = PaymentStatus.Pending;
            }

            payment.ChargedAmount = chargedAmount;
            payment.ChargedCurrency = MoneyPolicy.ProviderCurrency;

            var returnUrl = _configuration["PAYPAL:RETURN_URL"] ?? "https://example.com/paypal/return";
            var cancelUrl = _configuration["PAYPAL:CANCEL_URL"] ?? "https://example.com/paypal/cancel";

            // PayPal is charged the converted amount, never the KM figure.
            var order = await _payPal.CreateOrderAsync(chargedAmount, returnUrl, cancelUrl, cancellationToken);
            payment.PayPalOrderId = order.OrderId;

            await _context.SaveChangesAsync(cancellationToken);

            return new PaymentOrderCreateResponse
            {
                PaymentId = payment.Id,
                OrderId = order.OrderId,
                ApprovalUrl = order.ApprovalUrl,
                Amount = amount,
                Currency = MoneyPolicy.BusinessCurrency,
                ChargedAmount = chargedAmount,
                ChargedCurrency = MoneyPolicy.ProviderCurrency,
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
            payment.PaidAt = DateTime.UtcNow;
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
                        payment.PaidAt = DateTime.UtcNow;
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
                throw new ForbiddenException("Možete platiti samo vlastite termine.");
            }
            return Task.CompletedTask;
        }
    }
}
