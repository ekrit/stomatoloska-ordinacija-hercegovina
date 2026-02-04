using System;
using SOH.Model.Enums;

namespace SOH.Model.SearchObjects
{
    public class AppointmentSearchObject : BaseSearchObject
    {
        public int? PatientId { get; set; }
        public int? DoctorId { get; set; }
        public int? ServiceId { get; set; }
        public int? RoomId { get; set; }
        public AppointmentStatus? Status { get; set; }
        public DateTime? StartFrom { get; set; }
        public DateTime? StartTo { get; set; }
    }
}
