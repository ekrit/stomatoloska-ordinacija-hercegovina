using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class AdminController : BaseCRUDController<AdminResponse, AdminSearchObject, AdminUpsertRequest, AdminUpsertRequest>
    {
        public AdminController(IAdminService service) : base(service)
        {
        }
    }
}
