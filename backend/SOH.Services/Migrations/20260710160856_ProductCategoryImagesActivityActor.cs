using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace SOH.Services.Migrations
{
    /// <inheritdoc />
    public partial class ProductCategoryImagesActivityActor : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Category",
                table: "Products");

            migrationBuilder.AddColumn<byte[]>(
                name: "Picture",
                table: "Products",
                type: "varbinary(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ProductCategoryId",
                table: "Products",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "Bio",
                table: "Doctors",
                type: "nvarchar(1000)",
                maxLength: 1000,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UserId",
                table: "ActivityLogs",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Username",
                table: "ActivityLogs",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.CreateTable(
                name: "ProductCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(300)", maxLength: 300, nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductCategories", x => x.Id);
                });

            migrationBuilder.UpdateData(
                table: "Doctors",
                keyColumn: "UserId",
                keyValue: 3,
                column: "Bio",
                value: null);

            migrationBuilder.InsertData(
                table: "Patients",
                columns: new[] { "UserId", "DateOfBirth", "FirstName", "LastName", "Phone" },
                values: new object[,]
                {
                    { 2, new DateTime(1990, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Amel", "Musić", "" },
                    { 4, new DateTime(1995, 6, 15, 0, 0, 0, 0, DateTimeKind.Utc), "Test", "Test", "" }
                });

            migrationBuilder.InsertData(
                table: "ProductCategories",
                columns: new[] { "Id", "Description", "IsActive", "Name" },
                values: new object[,]
                {
                    { 1, "Ručne i električne četkice za zube.", true, "Četkice za zube" },
                    { 2, "Paste za svakodnevnu njegu i izbjeljivanje.", true, "Paste za zube" },
                    { 3, "Konac, interdentalne četkice i slično.", true, "Zubni konac i interdentalna njega" },
                    { 4, "Antibakterijske i vodice sa fluorom.", true, "Vodice za ispiranje" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "Id", "CityId", "CreatedAt", "Email", "FirstName", "GenderId", "IsActive", "LastLoginAt", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "Picture", "Role", "Username" },
                values: new object[,]
                {
                    { 5, 5, new DateTime(2025, 5, 5, 0, 0, 0, 0, DateTimeKind.Utc), "desktop@test.local", "Desktop", 1, true, null, "Admin", "6WQE4xWXatQu77nogrh2raYN+GAxq4kcCpJS3mvU56U=", "4Ey5Av2EasR6kBLnGz2eIg==", "+387 00 000 000", null, 3, "desktop" },
                    { 6, 5, new DateTime(2025, 5, 5, 0, 0, 0, 0, DateTimeKind.Utc), "mobile@test.local", "Mobile", 1, true, null, "Patient", "6WQE4xWXatQu77nogrh2raYN+GAxq4kcCpJS3mvU56U=", "4Ey5Av2EasR6kBLnGz2eIg==", "+387 00 000 000", null, 1, "mobile" },
                    { 7, 5, new DateTime(2025, 5, 5, 0, 0, 0, 0, DateTimeKind.Utc), "doctor@test.local", "Test", 1, true, null, "Doctor", "6WQE4xWXatQu77nogrh2raYN+GAxq4kcCpJS3mvU56U=", "4Ey5Av2EasR6kBLnGz2eIg==", "+387 00 000 000", null, 2, "doctor" }
                });

            migrationBuilder.InsertData(
                table: "Doctors",
                columns: new[] { "UserId", "Bio", "FirstName", "LastName", "Rating", "Specialization" },
                values: new object[] { 7, null, "Test", "Doctor", 4.50m, "General dentistry" });

            migrationBuilder.InsertData(
                table: "Patients",
                columns: new[] { "UserId", "DateOfBirth", "FirstName", "LastName", "Phone" },
                values: new object[] { 6, new DateTime(1992, 3, 20, 0, 0, 0, 0, DateTimeKind.Utc), "Mobile", "Patient", "" });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "Id", "DateAssigned", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 5, new DateTime(2025, 5, 5, 0, 0, 0, 0, DateTimeKind.Utc), 1, 5 },
                    { 6, new DateTime(2025, 5, 5, 0, 0, 0, 0, DateTimeKind.Utc), 2, 6 },
                    { 7, new DateTime(2025, 5, 5, 0, 0, 0, 0, DateTimeKind.Utc), 3, 7 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_Products_ProductCategoryId",
                table: "Products",
                column: "ProductCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_ActivityLogs_UserId",
                table: "ActivityLogs",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_ProductCategories_Name",
                table: "ProductCategories",
                column: "Name",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_ActivityLogs_Users_UserId",
                table: "ActivityLogs",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Products_ProductCategories_ProductCategoryId",
                table: "Products",
                column: "ProductCategoryId",
                principalTable: "ProductCategories",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ActivityLogs_Users_UserId",
                table: "ActivityLogs");

            migrationBuilder.DropForeignKey(
                name: "FK_Products_ProductCategories_ProductCategoryId",
                table: "Products");

            migrationBuilder.DropTable(
                name: "ProductCategories");

            migrationBuilder.DropIndex(
                name: "IX_Products_ProductCategoryId",
                table: "Products");

            migrationBuilder.DropIndex(
                name: "IX_ActivityLogs_UserId",
                table: "ActivityLogs");

            migrationBuilder.DeleteData(
                table: "Doctors",
                keyColumn: "UserId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Patients",
                keyColumn: "UserId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Patients",
                keyColumn: "UserId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Patients",
                keyColumn: "UserId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "UserRoles",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "UserRoles",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "UserRoles",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Users",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DropColumn(
                name: "Picture",
                table: "Products");

            migrationBuilder.DropColumn(
                name: "ProductCategoryId",
                table: "Products");

            migrationBuilder.DropColumn(
                name: "Bio",
                table: "Doctors");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "ActivityLogs");

            migrationBuilder.DropColumn(
                name: "Username",
                table: "ActivityLogs");

            migrationBuilder.AddColumn<string>(
                name: "Category",
                table: "Products",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");
        }
    }
}
