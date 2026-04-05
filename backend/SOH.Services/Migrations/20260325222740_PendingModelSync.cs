using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SOH.Services.Migrations
{
    /// <inheritdoc />
    public partial class PendingModelSync : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "PasswordHash", "PasswordSalt" },
                values: new object[] { "A73+rnMJ25Y/AhnRuEbJQDCDT+uXP8kpNtZ5bhS4fuA=", "fVmPGXAOrMU9qOyyeZgRlg==" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "PasswordHash", "PasswordSalt" },
                values: new object[] { "A73+rnMJ25Y/AhnRuEbJQDCDT+uXP8kpNtZ5bhS4fuA=", "fVmPGXAOrMU9qOyyeZgRlg==" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "PasswordHash", "PasswordSalt" },
                values: new object[] { "A73+rnMJ25Y/AhnRuEbJQDCDT+uXP8kpNtZ5bhS4fuA=", "fVmPGXAOrMU9qOyyeZgRlg==" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "PasswordHash", "PasswordSalt" },
                values: new object[] { "A73+rnMJ25Y/AhnRuEbJQDCDT+uXP8kpNtZ5bhS4fuA=", "fVmPGXAOrMU9qOyyeZgRlg==" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "PasswordHash", "PasswordSalt" },
                values: new object[] { "3KbrBi5n9zdQnceWWOK5zaeAwfEjsluyhRQUbNkcgLQ=", "6raKZCuEsvnBBxPKHGpRtA==" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "PasswordHash", "PasswordSalt" },
                values: new object[] { "kDPVcZaikiII7vXJbMEw6B0xZ245I29ocaxBjLaoAC0=", "O5R9WmM6IPCCMci/BCG/eg==" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "PasswordHash", "PasswordSalt" },
                values: new object[] { "BiWDuil9svAKOYzii5wopQW3YqjVfQrzGE2iwH/ylY4=", "pfNS+OLBaQeGqBIzXXcWuA==" });

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "PasswordHash", "PasswordSalt" },
                values: new object[] { "KUF0Jsocq9AqdwR9JnT2OrAqm5gDj7ecQvNwh6fW/Bs=", "c3ZKo0va3tYfnYuNKkHDbQ==" });
        }
    }
}
