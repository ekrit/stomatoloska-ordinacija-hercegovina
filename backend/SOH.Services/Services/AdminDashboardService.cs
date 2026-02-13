using Microsoft.EntityFrameworkCore;
using SOH.Model.Responses;
using SOH.Services.Database;
using SOH.Services.Interfaces;
using System.Globalization;

namespace SOH.Services.Services
{
    public class AdminDashboardService : IAdminDashboardService
    {
        private readonly SOHDbContext _context;

        public AdminDashboardService(SOHDbContext context)
        {
            _context = context;
        }

        public async Task<DashboardStatsResponse> GetDashboardStatsAsync()
        {
            var now = DateTime.UtcNow;
            var last30Days = now.AddDays(-30);
            var monthStart = new DateTime(now.Year, now.Month, 1, 0, 0, 0, DateTimeKind.Utc);

            var totalDoctors = await _context.Doctors.CountAsync();
            var totalPractices = await _context.Rooms.CountAsync();
            var totalUsers = await _context.Users.CountAsync();

            var completedAppointments = await _context.Appointments
                .CountAsync(a => a.Status == AppointmentStatus.Completed && a.StartTime >= last30Days);

            var cancelledAppointments = await _context.Appointments
                .CountAsync(a => a.Status == AppointmentStatus.Cancelled && a.StartTime >= last30Days);

            var paidTotalCurrent = await _context.Payments
                .Where(p => p.Status == PaymentStatus.Paid && p.CreatedAt >= last30Days)
                .SumAsync(p => (decimal?)p.Amount) ?? 0m;

            var averageEarnings = totalDoctors == 0
                ? 0m
                : Math.Round(paidTotalCurrent / totalDoctors, 2);

            var newPatientsThisMonth = await _context.UserRoles
                .Where(ur => ur.Role.Name == "User" && ur.User.CreatedAt >= monthStart)
                .Select(ur => ur.UserId)
                .Distinct()
                .CountAsync();

            var previousStart = last30Days.AddDays(-30);
            var paidTotalPrevious = await _context.Payments
                .Where(p => p.Status == PaymentStatus.Paid && p.CreatedAt >= previousStart && p.CreatedAt < last30Days)
                .SumAsync(p => (decimal?)p.Amount) ?? 0m;

            var revenueGrowth = paidTotalPrevious == 0m
                ? 0d
                : (double)((paidTotalCurrent - paidTotalPrevious) / paidTotalPrevious * 100m);

            return new DashboardStatsResponse
            {
                TotalDoctors = totalDoctors,
                TotalPractices = totalPractices,
                TotalUsers = totalUsers,
                CompletedAppointments = completedAppointments,
                CancelledAppointments = cancelledAppointments,
                AverageEarnings = averageEarnings,
                NewPatientsThisMonth = newPatientsThisMonth,
                RevenueGrowth = Math.Round(revenueGrowth, 1)
            };
        }

        public async Task<AppointmentStatsResponse> GetMonthlyAppointmentsAsync(int months)
        {
            var safeMonths = Math.Clamp(months, 1, 12);
            var now = DateTime.UtcNow;
            var end = new DateTime(now.Year, now.Month, 1, 0, 0, 0, DateTimeKind.Utc).AddMonths(1);
            var start = end.AddMonths(-safeMonths);

            var grouped = await _context.Appointments
                .Where(a => a.StartTime >= start && a.StartTime < end)
                .GroupBy(a => new { a.StartTime.Year, a.StartTime.Month })
                .Select(g => new { g.Key.Year, g.Key.Month, Count = g.Count() })
                .ToListAsync();

            var results = new List<MonthlyAppointmentResponse>();
            for (var i = 0; i < safeMonths; i++)
            {
                var monthDate = start.AddMonths(i);
                var monthLabel = CultureInfo.InvariantCulture.DateTimeFormat.AbbreviatedMonthNames[monthDate.Month - 1];
                var existing = grouped.FirstOrDefault(g => g.Year == monthDate.Year && g.Month == monthDate.Month);
                results.Add(new MonthlyAppointmentResponse
                {
                    Month = monthLabel,
                    Count = existing?.Count ?? 0
                });
            }

            return new AppointmentStatsResponse { Monthly = results };
        }

        public async Task<RevenueStatsResponse> GetRevenueBreakdownAsync(int months)
        {
            var safeMonths = Math.Clamp(months, 1, 12);
            var now = DateTime.UtcNow;
            var end = new DateTime(now.Year, now.Month, 1, 0, 0, 0, DateTimeKind.Utc).AddMonths(1);
            var start = end.AddMonths(-safeMonths);

            var grouped = await _context.Payments
                .Where(p => p.Status == PaymentStatus.Paid && p.CreatedAt >= start && p.CreatedAt < end)
                .Select(p => new { p.Amount, p.Appointment.Service.Name })
                .GroupBy(p => p.Name)
                .Select(g => new { Name = g.Key, Total = g.Sum(x => x.Amount) })
                .ToListAsync();

            var total = grouped.Sum(x => x.Total);
            if (total <= 0)
            {
                return new RevenueStatsResponse();
            }

            var categories = grouped
                .OrderByDescending(x => x.Total)
                .Take(6)
                .Select(x => new RevenueCategoryResponse
                {
                    Label = x.Name,
                    Value = Math.Round((double)(x.Total / total * 100m), 1)
                })
                .ToList();

            return new RevenueStatsResponse { Categories = categories };
        }

        public async Task<List<DoctorSpotlightResponse>> GetDoctorSpotlightAsync(int limit)
        {
            var safeLimit = Math.Clamp(limit, 1, 10);
            return await _context.Doctors
                .OrderByDescending(d => d.Rating)
                .Take(safeLimit)
                .Select(d => new DoctorSpotlightResponse
                {
                    Id = d.UserId,
                    Name = $"{d.FirstName} {d.LastName}".Trim(),
                    Specialization = d.Specialization,
                    AvatarUrl = null
                })
                .ToListAsync();
        }
    }
}
