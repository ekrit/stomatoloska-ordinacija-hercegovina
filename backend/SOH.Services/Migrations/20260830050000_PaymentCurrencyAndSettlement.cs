using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using SOH.Services.Database;

#nullable disable

namespace SOH.Services.Migrations
{
    /// <summary>
    /// Records the currency a payment is denominated in and, separately, what
    /// the provider was actually charged. PayPal cannot settle in BAM, so the
    /// KM amount and the converted EUR amount are both kept rather than the
    /// same decimal being relabelled.
    /// </summary>
    /// <inheritdoc />
    // The [Migration] attribute normally lives in the generated .Designer.cs
    // companion. This migration was written by hand (no dotnet-ef available in
    // the environment it was authored in), so the attribute is declared here to
    // keep the migration discoverable by Database.Migrate() at startup. The
    // model snapshot is updated alongside it; regenerating the Designer file is
    // only needed for future `dotnet ef migrations add` scaffolding.
    [DbContext(typeof(SOHDbContext))]
    [Migration("20260830050000_PaymentCurrencyAndSettlement")]
    public partial class PaymentCurrencyAndSettlement : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Currency",
                table: "Payments",
                type: "nvarchar(3)",
                maxLength: 3,
                nullable: false,
                defaultValue: "BAM");

            migrationBuilder.AddColumn<decimal>(
                name: "ChargedAmount",
                table: "Payments",
                type: "decimal(18,2)",
                precision: 18,
                scale: 2,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ChargedCurrency",
                table: "Payments",
                type: "nvarchar(3)",
                maxLength: 3,
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "PaidAt",
                table: "Payments",
                type: "datetime2",
                nullable: true);

            // Existing rows predate the split. They were charged as EUR while
            // the catalog priced them in KM, so their settlement side is left
            // unknown rather than guessed; Currency defaults to BAM to match
            // what Amount has always actually meant.
            // PaymentStatus.Paid == 2.
            migrationBuilder.Sql(
                "UPDATE [Payments] SET [PaidAt] = [CreatedAt] WHERE [Status] = 2 AND [PaidAt] IS NULL;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(name: "PaidAt", table: "Payments");
            migrationBuilder.DropColumn(name: "ChargedCurrency", table: "Payments");
            migrationBuilder.DropColumn(name: "ChargedAmount", table: "Payments");
            migrationBuilder.DropColumn(name: "Currency", table: "Payments");
        }
    }
}
