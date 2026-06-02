using SOH.Model.Requests;
using SOH.Model.Responses;
using SOH.Model.SearchObjects;
using SOH.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers
{

    public class RoleController : BaseCRUDController<RoleResponse, RoleSearchObject, RoleUpsertRequest, RoleUpsertRequest>
    {
        public RoleController(IRoleService service) : base(service)
        {
        }
        
        // Roles are sensitive metadata. Only staff (the desktop admin/doctor
        // user editor populates a role dropdown) may read them; patients and
        // anonymous callers cannot.
        [HttpGet]
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override async Task<PagedResult<RoleResponse>> Get([FromQuery] RoleSearchObject? search = null)
        {
            return await _service.GetAsync(search ?? new RoleSearchObject());
        }

        [HttpGet("{id}")]
        [Authorize(Roles = RoleNames.Administrator + "," + RoleNames.Doctor)]
        public override async Task<RoleResponse?> GetById(int id)
        {
            return await _service.GetByIdAsync(id);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<RoleResponse> Create([FromBody] RoleUpsertRequest request)
        {
            return await base.Create(request);
        }

        [Authorize(Roles = RoleNames.Administrator)]
        public override async Task<RoleResponse?> Update(int id, [FromBody] RoleUpsertRequest request)
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