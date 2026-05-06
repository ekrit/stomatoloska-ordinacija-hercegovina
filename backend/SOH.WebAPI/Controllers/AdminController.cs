using Microsoft.AspNetCore.Authorization;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    [Authorize(Roles = RoleNames.Administrator)]
    public class AdminController : BaseCRUDController<AdminResponse, AdminSearchObject, AdminUpsertRequest, AdminUpsertRequest>
    {
        public AdminController(IAdminService service) : base(service)
        {
        }
    }
}
