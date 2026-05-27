using System;

namespace SOH.Model.Responses
{
    public class OrderResponse
    {
        public int Id { get; set; }
        public int PatientId { get; set; }
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public decimal TotalAmount { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
