using System;

namespace SOH.Model.Exceptions
{
    /// <summary>
    /// Thrown when the caller is authenticated but has no right over the
    /// requested record (e.g. reading another patient's payment). Mapped to
    /// HTTP 403 by <c>SOH.WebAPI.Filters.ExceptionFilter</c>.
    /// </summary>
    public class ForbiddenException : Exception
    {
        public ForbiddenException(string message) : base(message) { }
        public ForbiddenException(string message, Exception inner) : base(message, inner) { }
    }
}
