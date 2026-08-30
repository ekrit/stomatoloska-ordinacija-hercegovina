using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace SOH.WebAPI.Controllers
{
    public class ReviewController : BaseCRUDController<ReviewResponse, ReviewSearchObject, ReviewUpsertRequest, ReviewUpsertRequest>
    {
        private readonly IReviewService _reviews;

        public ReviewController(IReviewService service) : base(service)
        {
            _reviews = service;
        }

        // Patients see only the reviews they authored; doctors see reviews
        // they received; admins see the whole feed.
        public override Task<PagedResult<ReviewResponse>> Get([FromQuery] ReviewSearchObject? search = null)
        {
            search ??= new ReviewSearchObject();
            if (!CallerIsAdmin)
            {
                if (CallerIsDoctor)
                {
                    search.DoctorId = CallerUserId;
                }
                else
                {
                    search.PatientId = CallerUserId;
                }
            }
            return base.Get(search);
        }

        public override async Task<ReviewResponse?> GetById(int id)
        {
            await EnsureCallerMayAccessAsync(_reviews, id);
            return await base.GetById(id);
        }

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override Task<ReviewResponse> Create([FromBody] ReviewUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override async Task<ReviewResponse?> Update(int id, [FromBody] ReviewUpsertRequest request)
        {
            await EnsureCallerMayAccessAsync(_reviews, id);
            return await base.Update(id, request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
