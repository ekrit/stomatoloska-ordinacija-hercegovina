using System;
using SOH.Model.Exceptions;

namespace SOH.Model
{
    /// <summary>
    /// Back-compat alias for callers that still throw the original
    /// <c>UserException</c>. New code should use <see cref="BusinessException"/>
    /// directly.
    /// </summary>
    public class UserException : BusinessException
    {
        public UserException(string message) : base(message) { }
        public UserException(string message, Exception inner) : base(message, inner) { }
    }
}
