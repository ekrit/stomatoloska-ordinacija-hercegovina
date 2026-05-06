using Microsoft.EntityFrameworkCore;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using SOH.Services.Database;
using SOH.Services.Interfaces;

namespace SOH.Services.Services;

public class ReportPdfService : IReportPdfService
{
    private readonly SOHDbContext _context;

    public ReportPdfService(SOHDbContext context)
    {
        _context = context;
        QuestPDF.Settings.License = LicenseType.Community;
    }

    public async Task<byte[]> BuildAppointmentsSummaryPdfAsync(DateTime fromUtc, DateTime toUtc, CancellationToken cancellationToken = default)
    {
        var rows = await _context.Appointments
            .AsNoTracking()
            .Where(a => a.StartTime >= fromUtc && a.StartTime <= toUtc)
            .OrderBy(a => a.StartTime)
            .Select(a => new AppointmentPdfRow(
                a.Id,
                a.StartTime,
                a.Patient.FirstName + " " + a.Patient.LastName,
                a.Service.Name,
                a.Status.ToString()))
            .ToListAsync(cancellationToken);

        return Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Margin(40);
                page.Header().Text("Appointments summary").FontSize(18).SemiBold();
                page.Content().PaddingTop(16).Column(col =>
                {
                    col.Spacing(6);
                    col.Item().Text($"Range (UTC): {fromUtc:u} – {toUtc:u}").FontSize(10).FontColor(Colors.Grey.Darken2);
                    col.Item().Text($"Total rows: {rows.Count}").SemiBold();

                    col.Item().PaddingTop(8).Table(table =>
                    {
                        table.ColumnsDefinition(c =>
                        {
                            c.ConstantColumn(40);
                            c.RelativeColumn(2);
                            c.RelativeColumn(2);
                            c.RelativeColumn(2);
                            c.RelativeColumn(1);
                        });
                        table.Header(h =>
                        {
                            h.Cell().Element(Head).Text("Id");
                            h.Cell().Element(Head).Text("Start (UTC)");
                            h.Cell().Element(Head).Text("Patient");
                            h.Cell().Element(Head).Text("Service");
                            h.Cell().Element(Head).Text("Status");
                        });
                        foreach (var r in rows)
                        {
                            table.Cell().Element(Cell).Text(r.Id.ToString());
                            table.Cell().Element(Cell).Text(r.StartTime.ToString("u"));
                            table.Cell().Element(Cell).Text(r.PatientName);
                            table.Cell().Element(Cell).Text(r.ServiceName);
                            table.Cell().Element(Cell).Text(r.Status);
                        }
                    });
                });
            });
        }).GeneratePdf();
    }

    public async Task<byte[]> BuildRevenueByServicePdfAsync(int months, CancellationToken cancellationToken = default)
    {
        months = Math.Clamp(months, 1, 24);
        var start = DateTime.UtcNow.Date.AddMonths(-months);

        var revenue = await _context.Payments
            .AsNoTracking()
            .Where(p => p.Status == PaymentStatus.Paid && p.CreatedAt >= start)
            .Join(_context.Appointments, p => p.AppointmentId, a => a.Id, (p, a) => new { p.Amount, a.ServiceId })
            .Join(_context.Services, x => x.ServiceId, s => s.Id, (x, s) => new { x.Amount, s.Name })
            .GroupBy(x => x.Name)
            .Select(g => new { Service = g.Key, Total = g.Sum(x => x.Amount) })
            .OrderByDescending(x => x.Total)
            .ToListAsync(cancellationToken);

        return Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Margin(40);
                page.Header().Text("Paid revenue by service").FontSize(18).SemiBold();
                page.Content().PaddingTop(16).Column(col =>
                {
                    col.Spacing(6);
                    col.Item().Text($"Window: last {months} month(s) from {start:u}").FontSize(10).FontColor(Colors.Grey.Darken2);

                    col.Item().PaddingTop(8).Table(table =>
                    {
                        table.ColumnsDefinition(c =>
                        {
                            c.RelativeColumn(3);
                            c.RelativeColumn(1);
                        });
                        table.Header(h =>
                        {
                            h.Cell().Element(Head).Text("Service");
                            h.Cell().Element(Head).Text("Total paid");
                        });
                        foreach (var r in revenue)
                        {
                            table.Cell().Element(Cell).Text(r.Service);
                            table.Cell().Element(Cell).Text(r.Total.ToString("F2"));
                        }
                    });
                });
            });
        }).GeneratePdf();
    }

    private static IContainer Head(IContainer c) =>
        c.DefaultTextStyle(x => x.SemiBold()).PaddingVertical(4).BorderBottom(1).BorderColor(Colors.Black);

    private static IContainer Cell(IContainer c) =>
        c.PaddingVertical(3).BorderBottom(1).BorderColor(Colors.Grey.Lighten2);

    private sealed record AppointmentPdfRow(int Id, DateTime StartTime, string PatientName, string ServiceName, string Status);
}
