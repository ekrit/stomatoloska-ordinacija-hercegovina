using SOH.Model.Enums;

namespace SOH.Model.SearchObjects
{
    public class PaymentSearchObject : BaseSearchObject
    {
        public int? AppointmentId { get; set; }
        public PaymentStatus? Status { get; set; }
        public string? Method { get; set; }
    }
}
