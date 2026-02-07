namespace SOH.Model.Responses
{
    public class DoctorResponse
    {
        public int UserId { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Specialization { get; set; } = string.Empty;
        public decimal Rating { get; set; }
    }
}
