using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers;

[ApiController]
[Route("report/pdf")]
[Authorize(Roles = RoleNames.Administrator)]
public class ReportPdfController : ControllerBase
{
    private readonly IReportPdfService _pdf;

    public ReportPdfController(IReportPdfService pdf)
    {
        _pdf = pdf;
    }

    [HttpGet("appointments-summary")]
    public async Task<IActionResult> AppointmentsSummary([FromQuery] DateTime? fromUtc, [FromQuery] DateTime? toUtc)
    {
        var to = toUtc ?? DateTime.UtcNow;
        var from = fromUtc ?? to.AddMonths(-1);
        if (from > to)
            (from, to) = (to, from);

        var bytes = await _pdf.BuildAppointmentsSummaryPdfAsync(from, to);
        var name = $"appointments-{from:yyyyMMdd}-{to:yyyyMMdd}.pdf";
        return File(bytes, "application/pdf", name);
    }

    [HttpGet("revenue-by-service")]
    public async Task<IActionResult> RevenueByService([FromQuery] int months = 6)
    {
        var bytes = await _pdf.BuildRevenueByServicePdfAsync(months);
        var name = $"revenue-by-service-{months}m-{DateTime.UtcNow:yyyyMMdd}.pdf";
        return File(bytes, "application/pdf", name);
    }
}
