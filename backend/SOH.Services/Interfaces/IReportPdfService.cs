namespace SOH.Services.Interfaces;

public interface IReportPdfService
{
    Task<byte[]> BuildAppointmentsSummaryPdfAsync(DateTime fromUtc, DateTime toUtc, CancellationToken cancellationToken = default);

    Task<byte[]> BuildRevenueByServicePdfAsync(int months, CancellationToken cancellationToken = default);
}
