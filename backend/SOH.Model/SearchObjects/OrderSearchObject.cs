using System;

namespace SOH.Model.SearchObjects
{
    public class OrderSearchObject : BaseSearchObject
    {
        public int? PatientId { get; set; }
        public DateTime? CreatedFrom { get; set; }
        public DateTime? CreatedTo { get; set; }
    }
}
