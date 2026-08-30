using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using SOH.Services.Database;

#nullable disable

namespace SOH.Services.Migrations
{
    /// <summary>
    /// Splits the single DoctorNote field into the three distinct things it was
    /// carrying (patient complaint, doctor's note, rejection reason), adds a
    /// cancellation reason, and introduces a status-history table recording who
    /// changed an appointment's status, when, between which states and why.
    /// </summary>
    /// <inheritdoc />
    // Hand-written: see the note on PaymentCurrencyAndSettlement. The
    // [Migration] attribute lives here rather than in a generated .Designer.cs
    // so Database.Migrate() still discovers it.
    [DbContext(typeof(SOHDbContext))]
    [Migration("20260830060000_AppointmentReasonsAndStatusAudit")]
    public partial class AppointmentReasonsAndStatusAudit : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "PatientComplaint",
                table: "Appointments",
                type: "nvarchar(2000)",
                maxLength: 2000,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DeclineReason",
                table: "Appointments",
                type: "nvarchar(2000)",
                maxLength: 2000,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "CancelReason",
                table: "Appointments",
                type: "nvarchar(2000)",
                maxLength: 2000,
                nullable: true);

            // Existing rows kept the patient's complaint (and the service name)
            // in DoctorNote, because booking wrote it there. Carry it across to
            // the field that now owns it; DoctorNote is left as-is rather than
            // cleared, since for declined visits it may hold the only reason
            // ever recorded.
            migrationBuilder.Sql(
                "UPDATE [Appointments] SET [PatientComplaint] = [DoctorNote] WHERE [DoctorNote] IS NOT NULL;");

            migrationBuilder.CreateTable(
                name: "AppointmentStatusHistories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AppointmentId = table.Column<int>(type: "int", nullable: false),
                    FromStatus = table.Column<int>(type: "int", nullable: false),
                    ToStatus = table.Column<int>(type: "int", nullable: false),
                    Reason = table.Column<string>(type: "nvarchar(2000)", maxLength: 2000, nullable: true),
                    ChangedByUserId = table.Column<int>(type: "int", nullable: true),
                    ChangedByUsername = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    ChangedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AppointmentStatusHistories", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AppointmentStatusHistories_Appointments_AppointmentId",
                        column: x => x.AppointmentId,
                        principalTable: "Appointments",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AppointmentStatusHistories_AppointmentId",
                table: "AppointmentStatusHistories",
                column: "AppointmentId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(name: "AppointmentStatusHistories");
            migrationBuilder.DropColumn(name: "CancelReason", table: "Appointments");
            migrationBuilder.DropColumn(name: "DeclineReason", table: "Appointments");
            migrationBuilder.DropColumn(name: "PatientComplaint", table: "Appointments");
        }
    }
}
