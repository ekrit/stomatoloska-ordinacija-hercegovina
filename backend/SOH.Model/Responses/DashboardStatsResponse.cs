namespace SOH.Model.Responses
{
    public class DashboardStatsResponse
    {
        public int ActiveUsers { get; set; }
        public int TotalDoctors { get; set; }
        /// <summary>Same as <see cref="TotalRooms"/>; kept for older clients.</summary>
        public int TotalPractices { get; set; }
        public int TotalRooms { get; set; }
        public int TotalUsers { get; set; }
        public int CompletedAppointments { get; set; }
        public int CancelledAppointments { get; set; }
        public decimal AverageEarnings { get; set; }
        public int NewPatientsThisMonth { get; set; }
        public double RevenueGrowth { get; set; }
    }
}
