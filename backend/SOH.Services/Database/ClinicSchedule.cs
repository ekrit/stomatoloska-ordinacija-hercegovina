namespace SOH.Services.Database
{
    /// <summary>
    /// The clinic's working hours and booking grid, defined server-side.
    /// <para>
    /// These used to live only in the Flutter client (<c>BookingConfig</c>),
    /// which meant the rules were advisory: a direct API call could book at
    /// 03:00 because nothing on the server disagreed. Availability is computed
    /// and re-validated against these values, and the client only renders what
    /// the server returns.
    /// </para>
    /// </summary>
    public static class ClinicSchedule
    {
        /// <summary>First hour a visit may start (local clinic time).</summary>
        public const int WorkdayStartHour = 8;

        /// <summary>Hour by which every visit must have ended.</summary>
        public const int WorkdayEndHour = 18;

        /// <summary>
        /// Spacing of candidate start times. A visit's length comes from the
        /// service, not from this: a 45-minute treatment simply occupies more
        /// of the day than a 30-minute one.
        /// </summary>
        public const int SlotStepMinutes = 30;

        /// <summary>True when the whole range fits inside one working day.</summary>
        public static bool IsWithinWorkingHours(DateTime start, DateTime end)
        {
            if (start.Date != end.Date)
            {
                return false;
            }

            var open = start.Date.AddHours(WorkdayStartHour);
            var close = start.Date.AddHours(WorkdayEndHour);
            return start >= open && end <= close;
        }
    }
}
