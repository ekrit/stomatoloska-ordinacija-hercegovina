namespace SOH.Services.Interfaces
{
    /// <summary>
    /// Which kind of user is acting on an appointment. Cancelling used to take
    /// a single "privileged" flag, which lumped doctors in with administrators
    /// and let one doctor cancel another doctor's appointment; the role has to
    /// be explicit so each one can be bound to the records it owns.
    /// </summary>
    public enum AppointmentActor
    {
        /// <summary>May act on appointments booked by them.</summary>
        Patient,

        /// <summary>May act on appointments assigned to them.</summary>
        Doctor,

        /// <summary>May act on any appointment.</summary>
        Administrator,
    }
}
