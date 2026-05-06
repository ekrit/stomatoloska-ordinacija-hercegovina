using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{
    public class RoomController : BaseCRUDController<RoomResponse, RoomSearchObject, RoomUpsertRequest, RoomUpsertRequest>
    {
        public RoomController(IRoomService service) : base(service)
        {
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<RoomResponse> Create([FromBody] RoomUpsertRequest request)
        {
            return await base.Create(request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<RoomResponse?> Update(int id, [FromBody] RoomUpsertRequest request)
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
