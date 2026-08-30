using Microsoft.EntityFrameworkCore;
using MapsterMapper;
using SOH.Model.Exceptions;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Database;
using SOH.Services.Interfaces;

namespace SOH.Services.Services
{
    public class AppointmentStatusTypeService
        : BaseCRUDService<StatusTypeResponse, StatusTypeSearchObject, AppointmentStatusType, StatusTypeUpsertRequest, StatusTypeUpsertRequest>,
          IAppointmentStatusTypeService
    {
        public AppointmentStatusTypeService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<AppointmentStatusType> ApplyFilter(IQueryable<AppointmentStatusType> query, StatusTypeSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    x.Name.Contains(search.FTS) ||
                    (x.Description != null && x.Description.Contains(search.FTS)));
            }

            return query.OrderBy(x => x.Id);
        }

        // The id is the enum value, so it is chosen by the caller rather than
        // generated, and must not collide with an existing row.
        protected override async Task BeforeInsert(AppointmentStatusType entity, StatusTypeUpsertRequest request)
        {
            if (await _context.AppointmentStatusTypes.AnyAsync(x => x.Id == request.Id))
            {
                throw new BusinessException("Status s ovom šifrom već postoji.");
            }
        }

        protected override Task BeforeUpdate(AppointmentStatusType entity, StatusTypeUpsertRequest request)
        {
            // Renaming is fine; renumbering would break the link to the enum.
            request.Id = entity.Id;
            return Task.CompletedTask;
        }

        protected override async Task BeforeDelete(AppointmentStatusType entity)
        {
            var status = (AppointmentStatus)entity.Id;
            if (await _context.Appointments.AnyAsync(a => a.Status == status))
            {
                throw new BusinessException("Status se ne može obrisati jer postoje termini koji ga koriste.");
            }
        }
    }

    public class PaymentStatusTypeService
        : BaseCRUDService<StatusTypeResponse, StatusTypeSearchObject, PaymentStatusType, StatusTypeUpsertRequest, StatusTypeUpsertRequest>,
          IPaymentStatusTypeService
    {
        public PaymentStatusTypeService(SOHDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        protected override IQueryable<PaymentStatusType> ApplyFilter(IQueryable<PaymentStatusType> query, StatusTypeSearchObject search)
        {
            if (!string.IsNullOrEmpty(search.Name))
            {
                query = query.Where(x => x.Name.Contains(search.Name));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(x =>
                    x.Name.Contains(search.FTS) ||
                    (x.Description != null && x.Description.Contains(search.FTS)));
            }

            return query.OrderBy(x => x.Id);
        }

        protected override async Task BeforeInsert(PaymentStatusType entity, StatusTypeUpsertRequest request)
        {
            if (await _context.PaymentStatusTypes.AnyAsync(x => x.Id == request.Id))
            {
                throw new BusinessException("Status s ovom šifrom već postoji.");
            }
        }

        protected override Task BeforeUpdate(PaymentStatusType entity, StatusTypeUpsertRequest request)
        {
            request.Id = entity.Id;
            return Task.CompletedTask;
        }

        protected override async Task BeforeDelete(PaymentStatusType entity)
        {
            var status = (PaymentStatus)entity.Id;
            if (await _context.Payments.AnyAsync(p => p.Status == status))
            {
                throw new BusinessException("Status se ne može obrisati jer postoje uplate koje ga koriste.");
            }
        }
    }
}
