using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    public class ServiceController : BaseCRUDController<ServiceResponse, ServiceSearchObject, ServiceUpsertRequest, ServiceUpsertRequest>
    {
        public ServiceController(IServiceService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<ServiceResponse> Create([FromBody] ServiceUpsertRequest request)
        {
            return await base.Create(request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<ServiceResponse?> Update(int id, [FromBody] ServiceUpsertRequest request)
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
