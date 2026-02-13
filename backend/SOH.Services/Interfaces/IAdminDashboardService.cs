using SOH.Model.Responses;

namespace SOH.Services.Interfaces
{
    public interface IAdminDashboardService
    {
        Task<DashboardStatsResponse> GetDashboardStatsAsync();
        Task<AppointmentStatsResponse> GetMonthlyAppointmentsAsync(int months);
        Task<RevenueStatsResponse> GetRevenueBreakdownAsync(int months);
        Task<List<DoctorSpotlightResponse>> GetDoctorSpotlightAsync(int limit);
    }
}
