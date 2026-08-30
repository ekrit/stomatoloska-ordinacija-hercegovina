using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using SOH.Services.Database;

#nullable disable

namespace SOH.Services.Migrations
{
    /// <summary>
    /// Enforces one hygiene entry per patient per day. Sequential POSTs could
    /// previously create several entries for the same day, after which the
    /// mobile app picked the first one and updated it arbitrarily.
    /// </summary>
    /// <inheritdoc />
    // Hand-written; see the note on PaymentCurrencyAndSettlement.
    [DbContext(typeof(SOHDbContext))]
    [Migration("20260830090000_HygieneDailyUniqueIndex")]
    public partial class HygieneDailyUniqueIndex : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Normalise first: a stored time component would make otherwise
            // duplicate days look distinct and the index would still build.
            migrationBuilder.Sql(
                "UPDATE [HygieneTrackers] SET [Date] = CAST([Date] AS date);");

            // Then drop duplicates, keeping the lowest id for each patient/day,
            // because a unique index cannot be created over existing conflicts.
            migrationBuilder.Sql(@"
DELETE h
FROM [HygieneTrackers] h
WHERE EXISTS (
    SELECT 1 FROM [HygieneTrackers] keep
    WHERE keep.[PatientId] = h.[PatientId]
      AND keep.[Date] = h.[Date]
      AND keep.[Id] < h.[Id]
);");

            migrationBuilder.CreateIndex(
                name: "IX_HygieneTrackers_PatientId_Date",
                table: "HygieneTrackers",
                columns: new[] { "PatientId", "Date" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_HygieneTrackers_PatientId_Date",
                table: "HygieneTrackers");
        }
    }
}
