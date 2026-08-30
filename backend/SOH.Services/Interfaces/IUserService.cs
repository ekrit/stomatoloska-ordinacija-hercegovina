using SOH.Model.Responses;
using SOH.Model.Requests;
using SOH.Model.SearchObjects;

namespace SOH.Services.Interfaces
{
    public interface IUserService : IService<UserResponse, UserSearchObject>
    {
        Task<UserResponse?> AuthenticateAsync(UserLoginRequest request);
        Task<UserResponse> CreateAsync(UserUpsertRequest request);

        /// <summary>
        /// Public registration: creates the user account, its roles, and the
        /// clinic Patient profile in a single transaction. This is the only
        /// path that creates a patient, so the real date of birth is required
        /// rather than defaulted to the registration date.
        /// </summary>
        Task<UserResponse> RegisterPatientAsync(UserUpsertRequest request, DateTime dateOfBirth);
        /// <summary>
        /// Updates a user. When <paramref name="callerIsAdmin"/> is false, the
        /// service ignores <see cref="UserUpsertRequest.RoleIds"/> and
        /// <see cref="UserUpsertRequest.IsActive"/>; this prevents a patient or
        /// doctor from escalating their own privileges or deactivating
        /// themselves via PUT /Users/{id}.
        /// </summary>
        Task<UserResponse?> UpdateAsync(int id, UserUpsertRequest request, bool callerIsAdmin);
        Task<bool> DeleteAsync(int id);

        /// <summary>
        /// Changes a user's own password after verifying the current one.
        /// Used by the self-service change-password flow on both clients.
        /// </summary>
        Task ChangeOwnPasswordAsync(int userId, string oldPassword, string newPassword);

        /// <summary>Raw avatar bytes for one user, or null when they have none.</summary>
        Task<byte[]?> GetPictureAsync(int id, CancellationToken cancellationToken = default);

        /// <summary>
        /// Issues a one-time reset code, or null when the identifier matches no
        /// active account. Callers must respond identically either way so the
        /// endpoint cannot be used to discover which accounts exist.
        /// </summary>
        Task<PasswordResetIssue?> RequestPasswordResetAsync(string usernameOrEmail, CancellationToken cancellationToken = default);

        /// <summary>Sets a new password after verifying the one-time code.</summary>
        Task ResetPasswordAsync(string usernameOrEmail, string code, string newPassword, CancellationToken cancellationToken = default);
    }

    /// <summary>A freshly issued reset code and who it belongs to.</summary>
    public readonly record struct PasswordResetIssue(
        int UserId,
        string Email,
        string FirstName,
        string Code,
        DateTime ExpiresAtUtc);
}
