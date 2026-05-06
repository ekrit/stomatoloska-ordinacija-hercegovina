using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SOH.Services.Database;

/// <summary>
/// Allows <c>dotnet ef</c> to run without starting SOH.WebAPI (avoids DLL locks when the API is running).
/// Connection string matches SOH.WebAPI/appsettings.json DefaultConnection for local dev.
/// </summary>
public sealed class DesignTimeDbContextFactory : IDesignTimeDbContextFactory<SOHDbContext>
{
    public SOHDbContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<SOHDbContext>();
        optionsBuilder.UseSqlServer(
            "Data Source=(localdb)\\MSSQLLocalDB;Initial Catalog=SOH_LocalDev;Integrated Security=True;");
        return new SOHDbContext(optionsBuilder.Options);
    }
}
