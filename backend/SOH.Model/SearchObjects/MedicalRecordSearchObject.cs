namespace SOH.Model.SearchObjects
{
    public class MedicalRecordSearchObject : BaseSearchObject
    {
        public int? AppointmentId { get; set; }

        // Scopes records to a patient through the owning appointment. Pinned
        // server-side for patient callers so they cannot read others' records.
        public int? PatientId { get; set; }
    }
}
