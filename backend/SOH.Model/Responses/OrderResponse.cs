using System;

namespace SOH.Model.Responses
{
    public class OrderResponse
    {
        public int Id { get; set; }
        public int PatientId { get; set; }
        public string PatientFirstName { get; set; } = string.Empty;
        public string PatientLastName { get; set; } = string.Empty;
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        /// <summary>
        /// Full product image. Populated on the details endpoint only; list
        /// rows leave this null and set <see cref="HasProductPicture"/>.
        /// </summary>
        public byte[]? ProductPicture { get; set; }

        /// <summary>True when the product has a picture.</summary>
        public bool HasProductPicture { get; set; }
        public int Quantity { get; set; }
        public decimal TotalAmount { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
