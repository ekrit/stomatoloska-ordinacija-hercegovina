using System;

namespace SOH.Model.SearchObjects
{
    public class ActivityLogSearchObject : BaseSearchObject
    {
        public string? Action { get; set; }
        public string? EntityName { get; set; }
        public string? EntityId { get; set; }
        public DateTime? CreatedFrom { get; set; }
        public DateTime? CreatedTo { get; set; }
    }
}
