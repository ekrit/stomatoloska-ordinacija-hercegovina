using System.ComponentModel.DataAnnotations;

namespace SOH.Model.Requests;

public class ProductInteractionTrackRequest
{
    [Required]
    public int ProductId { get; set; }

    /// <summary>View or DetailOpened</summary>
    [Required]
    [MaxLength(32)]
    public string Kind { get; set; } = "View";
}
