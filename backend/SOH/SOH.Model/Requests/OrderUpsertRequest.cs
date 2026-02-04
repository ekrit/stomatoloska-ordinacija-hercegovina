using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class OrderUpsertRequest
    {
        [Required]
        public int PatientId { get; set; }

        [Required]
        public decimal TotalAmount { get; set; }
    }
}
