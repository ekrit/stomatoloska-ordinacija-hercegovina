using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SOH.Services.Migrations
{
    /// <inheritdoc />
    public partial class DevSeedPasswordSohDev2026 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                column: "PasswordHash",
                value: "4BNQxOR2Z9YWxOvrV8d06ex8xsdPoxFIYOduR76p3PY=");

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                column: "PasswordHash",
                value: "4BNQxOR2Z9YWxOvrV8d06ex8xsdPoxFIYOduR76p3PY=");

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                column: "PasswordHash",
                value: "4BNQxOR2Z9YWxOvrV8d06ex8xsdPoxFIYOduR76p3PY=");

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                column: "PasswordHash",
                value: "4BNQxOR2Z9YWxOvrV8d06ex8xsdPoxFIYOduR76p3PY=");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 1,
                column: "PasswordHash",
                value: "A73+rnMJ25Y/AhnRuEbJQDCDT+uXP8kpNtZ5bhS4fuA=");

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 2,
                column: "PasswordHash",
                value: "A73+rnMJ25Y/AhnRuEbJQDCDT+uXP8kpNtZ5bhS4fuA=");

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 3,
                column: "PasswordHash",
                value: "A73+rnMJ25Y/AhnRuEbJQDCDT+uXP8kpNtZ5bhS4fuA=");

            migrationBuilder.UpdateData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 4,
                column: "PasswordHash",
                value: "A73+rnMJ25Y/AhnRuEbJQDCDT+uXP8kpNtZ5bhS4fuA=");
        }
    }
}
