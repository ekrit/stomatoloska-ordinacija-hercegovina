using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    public class GenderController : BaseCRUDController<GenderResponse, GenderSearchObject, GenderUpsertRequest, GenderUpsertRequest>
    {
        public GenderController(IGenderService service) : base(service)
        {
        }

        [AllowAnonymous]
        public override async Task<PagedResult<GenderResponse>> Get([FromQuery] GenderSearchObject? search = null)
        {
            return await base.Get(search);
        }

        [AllowAnonymous]
        public override async Task<GenderResponse?> GetById(int id)
        {
            return await base.GetById(id);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<GenderResponse> Create([FromBody] GenderUpsertRequest request)
        {
            return await base.Create(request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<GenderResponse?> Update(int id, [FromBody] GenderUpsertRequest request)
        {
            return await base.Update(id, request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<bool> Delete(int id)
        {
            return await base.Delete(id);
        }
    }
}