namespace SOH.Services.Interfaces
{
    /// <summary>
    /// Owners of a single user-data record. Both ids are <c>User.Id</c> values:
    /// the Patient and Doctor tables key off the user primary key, so the id in
    /// the JWT can be compared directly. A <c>null</c> component means the
    /// record has no owner of that kind.
    /// </summary>
    public readonly record struct RecordOwner(int? PatientId, int? DoctorId);

    /// <summary>
    /// Implemented by services whose records belong to a specific patient
    /// and/or doctor. Controllers use it to authorize single-record reads, so a
    /// known or guessed id cannot expose another user's data through a direct
    /// API call that bypasses the Flutter UI.
    /// </summary>
    public interface IRecordOwnership
    {
        /// <summary>
        /// Returns the owners of the record, or <c>null</c> when it does not exist.
        /// </summary>
        Task<RecordOwner?> GetOwnerAsync(int id, CancellationToken cancellationToken = default);
    }
}
