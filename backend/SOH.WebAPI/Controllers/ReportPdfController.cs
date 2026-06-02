using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SOH.Model.Requests;
using SOH.Services.Interfaces;
using SOH.WebAPI.Authorization;

namespace SOH.WebAPI.Controllers;

[ApiController]
[Route("report/pdf")]
[Authorize(Roles = RoleNames.Administrator)]
public class ReportPdfController : ControllerBase
{
    private readonly IReportPdfService _pdf;
    private readonly IReportService _reports;

    public ReportPdfController(IReportPdfService pdf, IReportService reports)
    {
        _pdf = pdf;
        _reports = reports;
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

        await _reports.CreateAsync(new ReportUpsertRequest
        {
            Type = "AppointmentsSummaryPdf",
            GeneratedAt = DateTime.UtcNow,
            Parameters = $"fromUtc={from:O};toUtc={to:O};fileName={name}"
        });

        return File(bytes, "application/pdf", name);
    }

    [HttpGet("revenue-by-service")]
    public async Task<IActionResult> RevenueByService([FromQuery] int months = 6)
    {
        var bytes = await _pdf.BuildRevenueByServicePdfAsync(months);
        var name = $"revenue-by-service-{months}m-{DateTime.UtcNow:yyyyMMdd}.pdf";

        await _reports.CreateAsync(new ReportUpsertRequest
        {
            Type = "RevenueByServicePdf",
            GeneratedAt = DateTime.UtcNow,
            Parameters = $"months={months};fileName={name}"
        });

        return File(bytes, "application/pdf", name);
    }
}
