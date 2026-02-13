using System.Collections.Generic;

namespace SOH.Model.Responses
{
    public class AppointmentStatsResponse
    {
        public List<MonthlyAppointmentResponse> Monthly { get; set; } = new List<MonthlyAppointmentResponse>();
    }
}
