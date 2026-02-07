using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    public class ServiceController : BaseCRUDController<ServiceResponse, ServiceSearchObject, ServiceUpsertRequest, ServiceUpsertRequest>
    {
        public ServiceController(IServiceService service) : base(service)
        {
        }
    }
}
