using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace SOH.Services.Database
{
    public static class DatabaseConfiguration
    {
        public static void AddDatabaseServices(this IServiceCollection services, string connectionString)
        {
            services.AddDbContext<SOHDbContext>(options =>
                options.UseSqlServer(connectionString));
        }

        public static void AddDatabaseSOH(this IServiceCollection services, string connectionString)
        {
            services.AddDbContext<SOHDbContext>(options =>
                options.UseSqlServer(connectionString));
        }
    }
}