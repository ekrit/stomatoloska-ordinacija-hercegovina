using System;

namespace SOH.Model.Responses
{
    public class HygieneTrackerResponse
    {
        public int Id { get; set; }
        public int PatientId { get; set; }
        public DateTime Date { get; set; }
        public int BrushesCount { get; set; }
    }
}
