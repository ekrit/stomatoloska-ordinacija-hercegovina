using System;

namespace SOH.Model.Responses
{
    /// <summary>
    /// A slot the server has confirmed is actually bookable: the doctor is
    /// free, a usable room is free, the whole visit fits the working day, and
    /// the length is the selected service's real duration.
    /// </summary>
    public class AvailabilitySlotResponse
    {
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }

        /// <summary>Room the server reserved this slot against.</summary>
        public int RoomId { get; set; }
        public string RoomName { get; set; } = string.Empty;
    }
}
