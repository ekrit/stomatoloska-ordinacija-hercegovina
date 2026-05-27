using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SOH.Services.Migrations
{
    /// <inheritdoc />
    public partial class RenameReportFilePathToParameters : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "FilePath",
                table: "Reports",
                newName: "Parameters");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Parameters",
                table: "Reports",
                newName: "FilePath");
        }
    }
}
