using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using SOH.Services.Database;

#nullable disable

namespace SOH.Services.Migrations
{
    /// <summary>
    /// Codebook tables for appointment and payment statuses, seeded from the
    /// enums they mirror. The enums remain the authority for behaviour; these
    /// rows make the labels and descriptions maintainable through the API and
    /// the desktop administration screens.
    /// </summary>
    /// <inheritdoc />
    // Hand-written; see the note on PaymentCurrencyAndSettlement.
    [DbContext(typeof(SOHDbContext))]
    [Migration("20260830070000_StatusCodebooks")]
    public partial class StatusCodebooks : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AppointmentStatusTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppointmentStatusTypes", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PaymentStatusTypes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PaymentStatusTypes", x => x.Id);
                });

            // The rows (ids matching the enum values) are seeded at runtime by
            // RuntimeDataSeeder, not via migrationBuilder.InsertData. This
            // migration is hand-written and carries no BuildTargetModel, so
            // Migrate() has no model to resolve InsertData column types from and
            // would throw "no entity type mapped to the table ..." when applying
            // it on a fresh database. CreateTable embeds its own column types, so
            // it applies fine; the seed is idempotent and runs after Migrate.
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(name: "PaymentStatusTypes");
            migrationBuilder.DropTable(name: "AppointmentStatusTypes");
        }
    }
}
