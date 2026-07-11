using System.Collections.Generic;

namespace SOH.Model.Responses
{
    public class PatientStatsResponse
    {
        /// <summary>New patient registrations per month, oldest first.</summary>
        public List<MonthlyAppointmentResponse> Monthly { get; set; } = new();
    }
}
