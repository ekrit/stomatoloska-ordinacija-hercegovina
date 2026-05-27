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
        public ReviewController(IReviewService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override Task<ReviewResponse> Create([FromBody] ReviewUpsertRequest request)
            => base.Create(request);

        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Patient)]
        public override Task<ReviewResponse?> Update(int id, [FromBody] ReviewUpsertRequest request)
            => base.Update(id, request);

        [Authorize(Roles = RoleNames.Administrator)]
        public override Task<bool> Delete(int id) => base.Delete(id);
    }
}
