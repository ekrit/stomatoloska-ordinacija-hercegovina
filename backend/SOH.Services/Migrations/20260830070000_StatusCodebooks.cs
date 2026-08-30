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

            // Ids match the enum values: AppointmentStatus 1..5, PaymentStatus 1..4.
            migrationBuilder.InsertData(
                table: "AppointmentStatusTypes",
                columns: new[] { "Id", "Name", "Description" },
                values: new object[,]
                {
                    { 1, "Zatražen", "Pacijent je poslao zahtjev; čeka se odgovor doktora." },
                    { 2, "Prihvaćen", "Doktor je prihvatio termin; plaćanje je moguće." },
                    { 3, "Odbijen", "Doktor je odbio zahtjev uz obavezan razlog." },
                    { 4, "Završen", "Termin je obavljen; moguća je recenzija." },
                    { 5, "Otkazan", "Termin je otkazan uz obavezan razlog." }
                });

            migrationBuilder.InsertData(
                table: "PaymentStatusTypes",
                columns: new[] { "Id", "Name", "Description" },
                values: new object[,]
                {
                    { 1, "Na čekanju", "PayPal narudžba je kreirana; naplata još nije potvrđena." },
                    { 2, "Plaćeno", "Naplata je potvrđena kroz PayPal." },
                    { 3, "Neuspjelo", "Naplata nije uspjela." },
                    { 4, "Refundirano", "Sredstva su vraćena pacijentu." }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(name: "PaymentStatusTypes");
            migrationBuilder.DropTable(name: "AppointmentStatusTypes");
        }
    }
}
