namespace SOH.Model.Responses
{
    public class DoctorSpotlightResponse
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Specialization { get; set; } = string.Empty;
        public string? AvatarUrl { get; set; }
    }
}
