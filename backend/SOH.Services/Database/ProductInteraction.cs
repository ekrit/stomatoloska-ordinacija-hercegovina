using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SOH.Services.Database;

public class ProductInteraction
{
    [Key]
    public int Id { get; set; }

    public int UserId { get; set; }

    public int ProductId { get; set; }

    public ProductInteractionKind Kind { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    [ForeignKey(nameof(UserId))]
    public User User { get; set; } = null!;

    [ForeignKey(nameof(ProductId))]
    public Product Product { get; set; } = null!;
}
