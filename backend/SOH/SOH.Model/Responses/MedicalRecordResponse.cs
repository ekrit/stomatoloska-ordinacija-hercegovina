using System;

namespace SOH.Model.Responses
{
    public class MedicalRecordResponse
    {
        public int Id { get; set; }
        public int AppointmentId { get; set; }
        public string Diagnosis { get; set; } = string.Empty;
        public string Treatment { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
    }
}
