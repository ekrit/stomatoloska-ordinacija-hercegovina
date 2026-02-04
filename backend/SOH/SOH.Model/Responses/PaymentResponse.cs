using System;
using SOH.Model.Enums;

namespace SOH.Model.Responses
{
    public class PaymentResponse
    {
        public int Id { get; set; }
        public int AppointmentId { get; set; }
        public decimal Amount { get; set; }
        public string Method { get; set; } = string.Empty;
        public PaymentStatus Status { get; set; }
        public string? TransactionRef { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
