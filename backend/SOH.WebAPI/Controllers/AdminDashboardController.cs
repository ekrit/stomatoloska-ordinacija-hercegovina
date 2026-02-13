using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Responses;
using SOH.Services.Interfaces;

namespace SOH.WebAPI.Controllers
{
    [ApiController]
    [Route("admin-dashboard")]
    [Authorize]
    public class AdminDashboardController : ControllerBase
    {
        private readonly IAdminDashboardService _service;

        public AdminDashboardController(IAdminDashboardService service)
        {
            _service = service;
        }

        [HttpGet("stats")]
        public async Task<DashboardStatsResponse> GetStats()
        {
            return await _service.GetDashboardStatsAsync();
        }

        [HttpGet("appointments/monthly")]
        public async Task<AppointmentStatsResponse> GetMonthlyAppointments([FromQuery] int months = 6)
        {
            return await _service.GetMonthlyAppointmentsAsync(months);
        }

        [HttpGet("revenue/breakdown")]
        public async Task<RevenueStatsResponse> GetRevenueBreakdown([FromQuery] int months = 6)
        {
            return await _service.GetRevenueBreakdownAsync(months);
        }

        [HttpGet("doctors/spotlight")]
        public async Task<List<DoctorSpotlightResponse>> GetDoctorSpotlight([FromQuery] int limit = 4)
        {
            return await _service.GetDoctorSpotlightAsync(limit);
        }
    }
}
