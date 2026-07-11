using SOH.Model.Responses;

namespace SOH.Services.Interfaces
{
    public interface IAdminDashboardService
    {
        Task<DashboardStatsResponse> GetDashboardStatsAsync();
        Task<AppointmentStatsResponse> GetMonthlyAppointmentsAsync(int months);
        Task<RevenueStatsResponse> GetRevenueBreakdownAsync(int months);
        Task<List<DoctorSpotlightResponse>> GetDoctorSpotlightAsync(int limit);
        Task<RecentActivityResponse> GetRecentActivityAsync(int take = 30);
        Task<PatientStatsResponse> GetMonthlyNewPatientsAsync(int months);
    }
}
