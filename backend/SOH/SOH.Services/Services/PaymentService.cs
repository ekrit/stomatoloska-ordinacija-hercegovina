using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using MapsterMapper;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class PaymentService : BaseCRUDService<PaymentResponse, PaymentSearchObject, Payment, PaymentUpsertRequest, PaymentUpsertRequest>, IPaymentService
    {
        public PaymentService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
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
    }
}
