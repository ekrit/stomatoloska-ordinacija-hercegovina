namespace SOH.Model.SearchObjects
{
    public class DoctorSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Specialization { get; set; }
    }
}
