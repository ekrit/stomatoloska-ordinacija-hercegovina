using System;

namespace SOH.Model.SearchObjects
{
    public class ReportSearchObject : BaseSearchObject
    {
        public string? Type { get; set; }
        public DateTime? GeneratedFrom { get; set; }
        public DateTime? GeneratedTo { get; set; }
    }
}
