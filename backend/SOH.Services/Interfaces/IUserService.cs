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
    }
}