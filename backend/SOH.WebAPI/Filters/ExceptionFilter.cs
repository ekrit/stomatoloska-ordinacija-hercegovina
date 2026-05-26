using SOH.Model;
using SOH.Model.Exceptions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System.Net;

namespace SOH.WebAPI.Filters
{
    /// <summary>
    /// Global exception filter. Maps known business exceptions to friendly
    /// HTTP status codes; everything else collapses to 500 with the
    /// underlying message hidden from the response.
    /// </summary>
    public class ExceptionFilter : ExceptionFilterAttribute
    {
        private readonly ILogger<ExceptionFilter> _logger;
        public ExceptionFilter(ILogger<ExceptionFilter> logger)
        {
            _logger = logger;
        }

        public override void OnException(ExceptionContext context)
        {
            _logger.LogError(context.Exception, context.Exception.Message);

            int statusCode;
            string errorKey;
            string errorMessage;

            switch (context.Exception)
            {
                case NotFoundException notFound:
                    statusCode = (int)HttpStatusCode.NotFound;
                    errorKey = "notFound";
                    errorMessage = notFound.Message;
                    break;

                case BusinessException businessError:
                    statusCode = (int)HttpStatusCode.BadRequest;
                    // UserException inherits BusinessException so the legacy
                    // `userError` key stays in the response for back-compat.
                    errorKey = context.Exception is UserException ? "userError" : "businessError";
                    errorMessage = businessError.Message;
                    break;

                default:
                    statusCode = (int)HttpStatusCode.InternalServerError;
                    errorKey = "ERROR";
                    errorMessage = "Server side error, please check logs";
                    break;
            }

            context.ModelState.AddModelError(errorKey, errorMessage);
            context.HttpContext.Response.StatusCode = statusCode;

            var list = context.ModelState
                .Where(x => x.Value != null && x.Value.Errors.Count > 0)
                .ToDictionary(
                    x => x.Key,
                    y => y.Value!.Errors.Select(z => z.ErrorMessage));

            context.Result = new JsonResult(new
            {
                errors = list
            });
        }
    }
}
