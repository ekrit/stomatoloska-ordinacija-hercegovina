using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SOH.Services.Database
{
    public class Admin
    {
        [Key]
        [ForeignKey(nameof(User))]
        public int UserId { get; set; }

        public User User { get; set; } = null!;
    }
}
