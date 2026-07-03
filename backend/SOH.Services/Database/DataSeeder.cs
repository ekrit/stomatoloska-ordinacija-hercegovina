using SOH.Services.Helpers;
using Microsoft.EntityFrameworkCore;

namespace SOH.Services.Database
{
    public static class DataSeeder
    {
        private const string DefaultPhoneNumber = "+387 00 000 000";
        
        private const string TestMailSender = "test.sender@gmail.com";
        private const string TestMailReceiver = "test.receiver@gmail.com";

        public static void SeedData(this ModelBuilder modelBuilder)
        {
            // Use a fixed date for all timestamps
            var fixedDate = new DateTime(2025, 5, 5, 0, 0, 0, DateTimeKind.Utc);

            // Seed Roles (JWT claim names; must match RoleNames in WebAPI)
            modelBuilder.Entity<Role>().HasData(
                new Role 
                { 
                    Id = 1, 
                    Name = "Administrator", 
                    Description = "System administrator with full access", 
                    CreatedAt = fixedDate, 
                    IsActive = true 
                },
                new Role 
                { 
                    Id = 2, 
                    Name = "Patient", 
                    Description = "Patient (registered user)", 
                    CreatedAt = fixedDate, 
                    IsActive = true 
                },
                new Role 
                { 
                    Id = 3, 
                    Name = "Doctor", 
                    Description = "Dentist / stomatologist", 
                    CreatedAt = fixedDate, 
                    IsActive = true 
                }
            );

            // Seed Users
            modelBuilder.Entity<User>().HasData(
                new User 
                {
                    Id = 1,
                    FirstName = "Denis",
                    LastName = "Mušić",
                    Email = TestMailReceiver,
                    Username = "admin",
                    Role = UserRoleType.Admin,
                    // Dev password: SohDev2026!
                    PasswordHash = "4BNQxOR2Z9YWxOvrV8d06ex8xsdPoxFIYOduR76p3PY=",
                    PasswordSalt = "fVmPGXAOrMU9qOyyeZgRlg==",
                    IsActive = true,
                    CreatedAt = fixedDate,
                    PhoneNumber = DefaultPhoneNumber,
                    GenderId = 1, // Male
                    CityId = 5, // Sarajevo
                    Picture = ImageConversion.ConvertImageToByteArray("Assets", "denis.png")
                },
                new User 
                { 
                    Id = 2, 
                    FirstName = "Amel", 
                    LastName = "Musić",
                    Email = "example1@gmail.com",
                    Username = "user",
                    Role = UserRoleType.Patient,
                    // Dev password: SohDev2026!
                    PasswordHash = "4BNQxOR2Z9YWxOvrV8d06ex8xsdPoxFIYOduR76p3PY=", 
                    PasswordSalt = "fVmPGXAOrMU9qOyyeZgRlg==", 
                    IsActive = true, 
                    CreatedAt = fixedDate,
                    PhoneNumber = DefaultPhoneNumber,
                    GenderId = 1, // Male
                    CityId = 5, // Mostar
                    Picture = ImageConversion.ConvertImageToByteArray("Assets", "amel.png")
                },
                new User 
                { 
                    Id = 3, 
                    FirstName = "Adil", 
                    LastName = "Joldić",
                    Email = "example2@gmail.com",
                    Username = "admin2",
                    Role = UserRoleType.Doctor,
                    // Dev password: SohDev2026!
                    PasswordHash = "4BNQxOR2Z9YWxOvrV8d06ex8xsdPoxFIYOduR76p3PY=", 
                    PasswordSalt = "fVmPGXAOrMU9qOyyeZgRlg==", 
                    IsActive = true, 
                    CreatedAt = fixedDate,
                    PhoneNumber = DefaultPhoneNumber,
                    GenderId = 1, // Male
                    CityId = 3, // Tuzla
                    Picture = ImageConversion.ConvertImageToByteArray("Assets", "adil.png")
                },
                new User 
                { 
                    Id = 4, 
                    FirstName = "Test", 
                    LastName = "Test", 
                    Email = TestMailSender, 
                    Username = "user2",
                    Role = UserRoleType.Patient,
                    // Dev password: SohDev2026!
                    PasswordHash = "4BNQxOR2Z9YWxOvrV8d06ex8xsdPoxFIYOduR76p3PY=", 
                    PasswordSalt = "fVmPGXAOrMU9qOyyeZgRlg==", 
                    IsActive = true, 
                    CreatedAt = fixedDate,
                    PhoneNumber = DefaultPhoneNumber,
                    GenderId = 2, // Female
                    CityId = 1, // Sarajevo
                    //Picture = ImageConversion.ConvertImageToByteArray("Assets", "test.png")
                },
                // Rubric-compliant test credentials (password: test)
                new User 
                { 
                    Id = 5, 
                    FirstName = "Desktop", 
                    LastName = "Admin", 
                    Email = "desktop@test.local", 
                    Username = "desktop",
                    Role = UserRoleType.Admin,
                    // Rubric password: test
                    PasswordHash = "6WQE4xWXatQu77nogrh2raYN+GAxq4kcCpJS3mvU56U=", 
                    PasswordSalt = "4Ey5Av2EasR6kBLnGz2eIg==", 
                    IsActive = true, 
                    CreatedAt = fixedDate,
                    PhoneNumber = DefaultPhoneNumber,
                    GenderId = 1,
                    CityId = 5
                },
                new User 
                { 
                    Id = 6, 
                    FirstName = "Mobile", 
                    LastName = "Patient", 
                    Email = "mobile@test.local", 
                    Username = "mobile",
                    Role = UserRoleType.Patient,
                    // Rubric password: test
                    PasswordHash = "6WQE4xWXatQu77nogrh2raYN+GAxq4kcCpJS3mvU56U=", 
                    PasswordSalt = "4Ey5Av2EasR6kBLnGz2eIg==", 
                    IsActive = true, 
                    CreatedAt = fixedDate,
                    PhoneNumber = DefaultPhoneNumber,
                    GenderId = 1,
                    CityId = 5
                },
                new User 
                { 
                    Id = 7, 
                    FirstName = "Test", 
                    LastName = "Doctor", 
                    Email = "doctor@test.local", 
                    Username = "doctor",
                    Role = UserRoleType.Doctor,
                    // Rubric password: test
                    PasswordHash = "6WQE4xWXatQu77nogrh2raYN+GAxq4kcCpJS3mvU56U=", 
                    PasswordSalt = "4Ey5Av2EasR6kBLnGz2eIg==", 
                    IsActive = true, 
                    CreatedAt = fixedDate,
                    PhoneNumber = DefaultPhoneNumber,
                    GenderId = 1,
                    CityId = 5
                }
            );

            // Seed UserRoles (JWT roles)
            modelBuilder.Entity<UserRole>().HasData(
                new UserRole { Id = 1, UserId = 1, RoleId = 1, DateAssigned = fixedDate }, 
                new UserRole { Id = 2, UserId = 2, RoleId = 2, DateAssigned = fixedDate }, 
                new UserRole { Id = 3, UserId = 3, RoleId = 3, DateAssigned = fixedDate }, 
                new UserRole { Id = 4, UserId = 4, RoleId = 2, DateAssigned = fixedDate },
                // Rubric-compliant test accounts
                new UserRole { Id = 5, UserId = 5, RoleId = 1, DateAssigned = fixedDate }, // desktop -> Administrator
                new UserRole { Id = 6, UserId = 6, RoleId = 2, DateAssigned = fixedDate }, // mobile -> Patient
                new UserRole { Id = 7, UserId = 7, RoleId = 3, DateAssigned = fixedDate }  // doctor -> Doctor
            );

            // Doctor profiles for seeded stomatologists
            modelBuilder.Entity<Doctor>().HasData(
                new Doctor
                {
                    UserId = 3,
                    FirstName = "Adil",
                    LastName = "Joldić",
                    Specialization = "Oral surgery",
                    Rating = 4.85m
                },
                new Doctor
                {
                    UserId = 7,
                    FirstName = "Test",
                    LastName = "Doctor",
                    Specialization = "General dentistry",
                    Rating = 4.50m
                }
            );
            
            // Patient profiles for seeded patients
            modelBuilder.Entity<Patient>().HasData(
                new Patient
                {
                    UserId = 2,
                    FirstName = "Amel",
                    LastName = "Musić",
                    DateOfBirth = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                },
                new Patient
                {
                    UserId = 4,
                    FirstName = "Test",
                    LastName = "Test",
                    DateOfBirth = new DateTime(1995, 6, 15, 0, 0, 0, DateTimeKind.Utc)
                },
                new Patient
                {
                    UserId = 6,
                    FirstName = "Mobile",
                    LastName = "Patient",
                    DateOfBirth = new DateTime(1992, 3, 20, 0, 0, 0, DateTimeKind.Utc)
                }
            );

            // Clinical rooms (required for appointment booking)
            modelBuilder.Entity<Room>().HasData(
                new Room { Id = 1, Name = "Ordinacija 1", IsAvailable = true },
                new Room { Id = 2, Name = "Ordinacija 2", IsAvailable = true }
            );

            // Services offered at the clinic (required for booking flow)
            modelBuilder.Entity<Service>().HasData(
                new Service
                {
                    Id = 1,
                    Name = "Pregled i savjet",
                    Description = "Preventivni stomatološki pregled.",
                    Price = 50.00m,
                    DurationMinutes = 30
                },
                new Service
                {
                    Id = 2,
                    Name = "Čišćenje zuba (profesionalno)",
                    Description = "Uklanjanje zubnog kamenca i poliranje.",
                    Price = 80.00m,
                    DurationMinutes = 45
                },
                new Service
                {
                    Id = 3,
                    Name = "Vađenje zuba",
                    Description = "Jednostavna ekstrakcija.",
                    Price = 120.00m,
                    DurationMinutes = 60
                },
                new Service
                {
                    Id = 4,
                    Name = "Plomba (komposit)",
                    Description = "Ispun kompozitnim materijalom.",
                    Price = 90.00m,
                    DurationMinutes = 45
                }
            );

            // Seed Genders
            modelBuilder.Entity<Gender>().HasData(
                new Gender { Id = 1, Name = "Male" },
                new Gender { Id = 2, Name = "Female" }
            );

            // Seed Cities
            modelBuilder.Entity<City>().HasData(
                new City { Id = 1, Name = "Sarajevo" },
                new City { Id = 2, Name = "Banja Luka" },
                new City { Id = 3, Name = "Tuzla" },
                new City { Id = 4, Name = "Zenica" },
                new City { Id = 5, Name = "Mostar" },
                new City { Id = 6, Name = "Bijeljina" },
                new City { Id = 7, Name = "Prijedor" },
                new City { Id = 8, Name = "Brčko" },
                new City { Id = 9, Name = "Doboj" },
                new City { Id = 10, Name = "Zvornik" }
            );
        }
    }
} 