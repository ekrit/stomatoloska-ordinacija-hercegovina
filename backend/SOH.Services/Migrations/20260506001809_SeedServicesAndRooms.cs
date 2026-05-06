using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace SOH.Services.Migrations
{
    /// <inheritdoc />
    public partial class SeedServicesAndRooms : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Rooms",
                columns: new[] { "Id", "IsAvailable", "Name" },
                values: new object[,]
                {
                    { 1, true, "Ordinacija 1" },
                    { 2, true, "Ordinacija 2" }
                });

            migrationBuilder.InsertData(
                table: "Services",
                columns: new[] { "Id", "Description", "DurationMinutes", "Name", "Price" },
                values: new object[,]
                {
                    { 1, "Preventivni stomatološki pregled.", 30, "Pregled i savjet", 50.00m },
                    { 2, "Uklanjanje zubnog kamenca i poliranje.", 45, "Čišćenje zuba (profesionalno)", 80.00m },
                    { 3, "Jednostavna ekstrakcija.", 60, "Vađenje zuba", 120.00m },
                    { 4, "Ispun kompozitnim materijalom.", 45, "Plomba (komposit)", 90.00m }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Rooms",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Services",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Services",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Services",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Services",
                keyColumn: "Id",
                keyValue: 4);
        }
    }
}
