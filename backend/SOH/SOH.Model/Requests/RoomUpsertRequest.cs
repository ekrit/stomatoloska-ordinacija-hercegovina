using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests
{
    public class RoomUpsertRequest
    {
        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;

        public bool IsAvailable { get; set; } = true;
    }
}
