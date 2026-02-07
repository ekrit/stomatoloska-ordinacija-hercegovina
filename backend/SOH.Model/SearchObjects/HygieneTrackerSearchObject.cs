using System;

namespace SOH.Model.SearchObjects
{
    public class HygieneTrackerSearchObject : BaseSearchObject
    {
        public int? PatientId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
    }
}
