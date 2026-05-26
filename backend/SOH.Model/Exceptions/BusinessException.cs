using System;

namespace SOH.Model.Exceptions
{
    /// <summary>
    /// Thrown when a request violates a business rule (e.g. duplicate name,
    /// invalid state transition, overlapping booking). Mapped to HTTP 400 by
    /// <c>SOH.WebAPI.Filters.ExceptionFilter</c>.
    /// </summary>
    public class BusinessException : Exception
    {
        public BusinessException(string message) : base(message) { }
        public BusinessException(string message, Exception inner) : base(message, inner) { }
    }
}
