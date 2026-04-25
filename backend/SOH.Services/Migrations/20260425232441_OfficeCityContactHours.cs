using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SOH.Services.Migrations
{
    /// <inheritdoc />
    public partial class OfficeCityContactHours : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Address",
                table: "Cities",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ContactEmail",
                table: "Cities",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ContactPhone",
                table: "Cities",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "WorkingHours",
                table: "Cities",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.UpdateData(
                table: "Cities",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "Address", "ContactEmail", "ContactPhone", "WorkingHours" },
                values: new object[] { null, null, null, null });

            migrationBuilder.UpdateData(
                table: "Cities",
                keyColumn: "Id",
                keyValue: 2,
                columns: new[] { "Address", "ContactEmail", "ContactPhone", "WorkingHours" },
                values: new object[] { null, null, null, null });

            migrationBuilder.UpdateData(
                table: "Cities",
                keyColumn: "Id",
                keyValue: 3,
                columns: new[] { "Address", "ContactEmail", "ContactPhone", "WorkingHours" },
                values: new object[] { null, null, null, null });

            migrationBuilder.UpdateData(
                table: "Cities",
                keyColumn: "Id",
                keyValue: 4,
                columns: new[] { "Address", "ContactEmail", "ContactPhone", "WorkingHours" },
                values: new object[] { null, null, null, null });

            migrationBuilder.UpdateData(
                table: "Cities",
                keyColumn: "Id",
                keyValue: 5,
                columns: new[] { "Address", "ContactEmail", "ContactPhone", "WorkingHours" },
                values: new object[] { null, null, null, null });

            migrationBuilder.UpdateData(
                table: "Cities",
                keyColumn: "Id",
                keyValue: 6,
                columns: new[] { "Address", "ContactEmail", "ContactPhone", "WorkingHours" },
                values: new object[] { null, null, null, null });

            migrationBuilder.UpdateData(
                table: "Cities",
                keyColumn: "Id",
                keyValue: 7,
                columns: new[] { "Address", "ContactEmail", "ContactPhone", "WorkingHours" },
                values: new object[] { null, null, null, null });

            migrationBuilder.UpdateData(
                table: "Cities",
                keyColumn: "Id",
                keyValue: 8,
                columns: new[] { "Address", "ContactEmail", "ContactPhone", "WorkingHours" },
                values: new object[] { null, null, null, null });

            migrationBuilder.UpdateData(
                table: "Cities",
                keyColumn: "Id",
                keyValue: 9,
                columns: new[] { "Address", "ContactEmail", "ContactPhone", "WorkingHours" },
                values: new object[] { null, null, null, null });

            migrationBuilder.UpdateData(
                table: "Cities",
                keyColumn: "Id",
                keyValue: 10,
                columns: new[] { "Address", "ContactEmail", "ContactPhone", "WorkingHours" },
                values: new object[] { null, null, null, null });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Address",
                table: "Cities");

            migrationBuilder.DropColumn(
                name: "ContactEmail",
                table: "Cities");

            migrationBuilder.DropColumn(
                name: "ContactPhone",
                table: "Cities");

            migrationBuilder.DropColumn(
                name: "WorkingHours",
                table: "Cities");
        }
    }
}
