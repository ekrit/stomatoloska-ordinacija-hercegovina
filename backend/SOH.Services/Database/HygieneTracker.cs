using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SOH.Services.Database
{
    public class HygieneTracker
    {
        [Key]
        public int Id { get; set; }

        public int PatientId { get; set; }

        public DateTime Date { get; set; }

        public int BrushesCount { get; set; }

        [ForeignKey(nameof(PatientId))]
        public Patient Patient { get; set; } = null!;
    }
}
