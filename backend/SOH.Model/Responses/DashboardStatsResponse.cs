namespace SOH.Model.Responses
{
    public class DashboardStatsResponse
    {
        public int TotalDoctors { get; set; }
        public int TotalPractices { get; set; }
        public int TotalUsers { get; set; }
        public int CompletedAppointments { get; set; }
        public int CancelledAppointments { get; set; }
        public decimal AverageEarnings { get; set; }
        public int NewPatientsThisMonth { get; set; }
        public double RevenueGrowth { get; set; }
    }
}
