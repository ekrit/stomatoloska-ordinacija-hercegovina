using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests;

public class PaymentOrderCreateRequest
{
    [Required]
    public int AppointmentId { get; set; }
}
