using System;

namespace SOH.Model.Exceptions
{
    /// <summary>
    /// Thrown when the requested entity does not exist. Mapped to HTTP 404 by
    /// <c>SOH.WebAPI.Filters.ExceptionFilter</c>.
    /// </summary>
    public class NotFoundException : Exception
    {
        public NotFoundException(string message) : base(message) { }
        public NotFoundException(string message, Exception inner) : base(message, inner) { }
    }
}
