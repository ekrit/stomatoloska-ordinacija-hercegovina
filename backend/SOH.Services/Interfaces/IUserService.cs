using SOH.Model.Responses;
using SOH.Model.Requests;
using SOH.Model.SearchObjects;
using SOH.Services.Services;

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
    }
}