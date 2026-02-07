namespace SOH.Model.SearchObjects
{
    public class ReviewSearchObject : BaseSearchObject
    {
        public int? AppointmentId { get; set; }
        public int? PatientId { get; set; }
        public int? DoctorId { get; set; }
        public int? Rating { get; set; }
    }
}
