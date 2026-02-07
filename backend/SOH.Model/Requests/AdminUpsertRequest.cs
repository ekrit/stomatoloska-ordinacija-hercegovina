using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class AdminUpsertRequest
    {
        [Required]
        public int UserId { get; set; }
    }
}
