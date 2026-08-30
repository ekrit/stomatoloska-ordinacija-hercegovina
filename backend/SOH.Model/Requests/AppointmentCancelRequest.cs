using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    /// <summary>
    /// Body for cancelling an appointment. The reason is recorded in the status
    /// history and sent to the patient in the notification; cancelling used to
    /// take no body at all and notified with a null reason.
    /// </summary>
    public class AppointmentCancelRequest
    {
        [Required(ErrorMessage = "Razlog otkazivanja je obavezan.")]
        [MinLength(3, ErrorMessage = "Razlog otkazivanja mora imati najmanje 3 znaka.")]
        [MaxLength(2000)]
        public string Reason { get; set; } = string.Empty;
    }
}
