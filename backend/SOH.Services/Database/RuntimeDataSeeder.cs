using Microsoft.EntityFrameworkCore;
using SOH.Services.Helpers;

namespace SOH.Services.Database
{
    /// <summary>
    /// Idempotent runtime seeder for demo/testing data that is awkward to bake
    /// into migrations (images, relative dates). Runs after migrations on
    /// startup; each domain seeds only when its table is empty, so restarts
    /// and existing databases are safe. Reference data (roles, users, cities,
    /// genders, services, rooms, product categories) stays in the HasData
    /// seed (<see cref="DataSeeder"/>).
    /// </summary>
    public static class RuntimeDataSeeder
    {
        // Users seeded by DataSeeder: 1 admin, 2/4/6 patients, 3/7 doctors.
        private const int PatientAmel = 2;
        private const int PatientTest = 4;
        private const int PatientMobile = 6;
        private const int DoctorAdil = 3;
        private const int DoctorTest = 7;

        public static async Task SeedAsync(SOHDbContext context)
        {
            var seededProducts = await SeedProductsAsync(context);
            var seededAppointments = await SeedAppointmentsAsync(context);
            if (seededAppointments)
            {
                await SeedMedicalRecordsAndPaymentsAndReviewsAsync(context);
            }
            if (seededProducts)
            {
                await SeedOrdersAndInteractionsAsync(context);
            }
            await SeedHygieneAsync(context);
            await SeedNotificationsAsync(context);
            await SeedActivityLogsAsync(context);
        }

        private static async Task<bool> SeedProductsAsync(SOHDbContext context)
        {
            if (await context.Products.AnyAsync())
                return false;

            var products = new List<Product>
            {
                NewProduct("Meka četkica Sensitive", "Ultra mekana četkica za osjetljivo zubno meso.", 6.90m, 1, "product-brush-soft.png"),
                NewProduct("Električna četkica ProClean", "Električna četkica sa tajmerom od 2 minute.", 89.00m, 1, "product-brush-electric.png"),
                NewProduct("Dječija četkica Junior", "Vesela četkica prilagođena dječijim rukama.", 4.50m, 1, "product-brush-kids.png"),
                NewProduct("Pasta za izbjeljivanje White+", "Pasta za blago izbjeljivanje uz svakodnevnu upotrebu.", 8.90m, 2, "product-paste-white.png"),
                NewProduct("Pasta Sensitive Repair", "Pasta za osjetljive zube sa kalijem i fluorom.", 9.40m, 2, "product-paste-sensitive.png"),
                NewProduct("Pasta Fluor Protect", "Svakodnevna zaštita od karijesa sa 1450 ppm fluora.", 5.80m, 2, "product-paste-fluor.png"),
                NewProduct("Zubni konac Fresh Mint", "Voskirani konac sa okusom mente, 50 m.", 3.20m, 3, "product-floss.png"),
                NewProduct("Interdentalne četkice 0.5 mm", "Pakovanje od 8 interdentalnih četkica.", 6.10m, 3, "product-interdental.png"),
                NewProduct("Vodica Mint Fresh 500 ml", "Antibakterijska vodica za svakodnevno ispiranje.", 7.50m, 4, "product-mouthwash-mint.png"),
                NewProduct("Vodica Fluor Shield 500 ml", "Vodica sa fluorom za dodatnu zaštitu cakline.", 8.20m, 4, "product-mouthwash-fluor.png"),
            };

            context.Products.AddRange(products);
            await context.SaveChangesAsync();
            return true;
        }

        private static Product NewProduct(string name, string description, decimal price, int categoryId, string imageName)
        {
            return new Product
            {
                Name = name,
                Description = description,
                Price = price,
                ProductCategoryId = categoryId,
                Picture = ImageConversion.ConvertImageToByteArray("Assets", imageName)
            };
        }

        private static async Task<bool> SeedAppointmentsAsync(SOHDbContext context)
        {
            if (await context.Appointments.AnyAsync())
                return false;

            var now = DateTime.UtcNow;
            var appointments = new List<Appointment>();

            // Completed visits in the past (reviews, findings, payments hang off these).
            appointments.Add(Appt(PatientAmel, DoctorAdil, 1, 1, now.AddDays(-40).Date.AddHours(9), 30, AppointmentStatus.Completed, "Redovan pregled, bez nalaza."));
            appointments.Add(Appt(PatientAmel, DoctorAdil, 2, 1, now.AddDays(-25).Date.AddHours(11), 45, AppointmentStatus.Completed, "Uklonjen kamenac."));
            appointments.Add(Appt(PatientAmel, DoctorTest, 4, 2, now.AddDays(-10).Date.AddHours(13), 45, AppointmentStatus.Completed, "Plomba na gornjem lijevom šestici."));
            appointments.Add(Appt(PatientTest, DoctorTest, 1, 2, now.AddDays(-35).Date.AddHours(10), 30, AppointmentStatus.Completed, "Preporučena kontrola za 6 mjeseci."));
            appointments.Add(Appt(PatientTest, DoctorAdil, 3, 1, now.AddDays(-18).Date.AddHours(14), 60, AppointmentStatus.Completed, "Ekstrakcija umnjaka, kontrola za 7 dana."));
            appointments.Add(Appt(PatientMobile, DoctorAdil, 1, 2, now.AddDays(-30).Date.AddHours(9, 30), 30, AppointmentStatus.Completed, "Prvi pregled, dobro stanje."));
            appointments.Add(Appt(PatientMobile, DoctorTest, 2, 1, now.AddDays(-8).Date.AddHours(12), 45, AppointmentStatus.Completed, "Profesionalno čišćenje završeno."));

            // Upcoming accepted visits.
            appointments.Add(Appt(PatientAmel, DoctorAdil, 1, 1, now.AddDays(5).Date.AddHours(9), 30, AppointmentStatus.Accepted, null));
            appointments.Add(Appt(PatientTest, DoctorTest, 2, 2, now.AddDays(7).Date.AddHours(11), 45, AppointmentStatus.Accepted, null));
            appointments.Add(Appt(PatientMobile, DoctorAdil, 4, 1, now.AddDays(9).Date.AddHours(13), 45, AppointmentStatus.Accepted, null));

            // Pending requests for the doctor inbox.
            appointments.Add(Appt(PatientAmel, DoctorTest, 3, 2, now.AddDays(12).Date.AddHours(10), 60, AppointmentStatus.Requested, null));
            appointments.Add(Appt(PatientTest, DoctorAdil, 1, 1, now.AddDays(14).Date.AddHours(9), 30, AppointmentStatus.Requested, null));
            appointments.Add(Appt(PatientMobile, DoctorTest, 2, 2, now.AddDays(15).Date.AddHours(12), 45, AppointmentStatus.Requested, null));
            appointments.Add(Appt(PatientMobile, DoctorAdil, 1, 2, now.AddDays(20).Date.AddHours(15), 30, AppointmentStatus.Requested, null));

            // Declined with mandatory reason.
            appointments.Add(Appt(PatientAmel, DoctorAdil, 4, 1, now.AddDays(-5).Date.AddHours(9), 45, AppointmentStatus.Declined, "Doktor odsutan tog dana, molimo odaberite drugi termin."));
            appointments.Add(Appt(PatientMobile, DoctorTest, 3, 2, now.AddDays(-3).Date.AddHours(14), 60, AppointmentStatus.Declined, "Traženi zahvat zahtijeva prethodni pregled."));

            // Cancelled history.
            appointments.Add(Appt(PatientAmel, DoctorTest, 1, 1, now.AddDays(-15).Date.AddHours(10), 30, AppointmentStatus.Cancelled, null));
            appointments.Add(Appt(PatientTest, DoctorAdil, 2, 2, now.AddDays(-12).Date.AddHours(11), 45, AppointmentStatus.Cancelled, null));
            appointments.Add(Appt(PatientMobile, DoctorAdil, 1, 1, now.AddDays(-6).Date.AddHours(16), 30, AppointmentStatus.Cancelled, null));
            appointments.Add(Appt(PatientTest, DoctorTest, 4, 1, now.AddDays(-2).Date.AddHours(9), 45, AppointmentStatus.Cancelled, null));

            context.Appointments.AddRange(appointments);
            await context.SaveChangesAsync();
            return true;
        }

        private static Appointment Appt(int patientId, int doctorId, int serviceId, int roomId, DateTime start, int minutes, AppointmentStatus status, string? note)
        {
            return new Appointment
            {
                PatientId = patientId,
                DoctorId = doctorId,
                ServiceId = serviceId,
                RoomId = roomId,
                StartTime = start,
                EndTime = start.AddMinutes(minutes),
                Status = status,
                DoctorNote = note
            };
        }

        private static DateTime AddHours(this DateTime date, int hours, int minutes) => date.AddHours(hours).AddMinutes(minutes);

        private static async Task SeedMedicalRecordsAndPaymentsAndReviewsAsync(SOHDbContext context)
        {
            var completed = await context.Appointments
                .Where(a => a.Status == AppointmentStatus.Completed)
                .OrderBy(a => a.StartTime)
                .ToListAsync();

            if (completed.Count == 0)
                return;

            if (!await context.MedicalRecords.AnyAsync())
            {
                var diagnoses = new (string Diagnosis, string Treatment)[]
                {
                    ("Zdravi zubi, blaga gingivitis reakcija.", "Preporučeno redovno pranje 2x dnevno i upotreba zubnog konca."),
                    ("Zubni kamenac na donjim sjekutićima.", "Obavljeno profesionalno čišćenje i poliranje."),
                    ("Karijes na zubu 26.", "Postavljena kompozitna plomba, kontrola za 6 mjeseci."),
                    ("Uredna denticija.", "Nastaviti postojeću rutinu oralne higijene."),
                    ("Impaktiran umnjak 38.", "Izvršena ekstrakcija, propisan analgetik po potrebi."),
                    ("Početna demineralizacija cakline.", "Preporučena pasta sa 1450 ppm fluora."),
                    ("Osjetljivost na hladno u regiji 14-16.", "Preporučena pasta za osjetljive zube i mekša četkica."),
                };

                for (var i = 0; i < completed.Count && i < diagnoses.Length; i++)
                {
                    context.MedicalRecords.Add(new MedicalRecord
                    {
                        AppointmentId = completed[i].Id,
                        Diagnosis = diagnoses[i].Diagnosis,
                        Treatment = diagnoses[i].Treatment,
                        CreatedAt = completed[i].EndTime
                    });
                }
                await context.SaveChangesAsync();
            }

            if (!await context.Payments.AnyAsync())
            {
                var servicePrices = await context.Services.ToDictionaryAsync(s => s.Id, s => s.Price);
                // Pay for a subset so the demo also shows unpaid completed visits.
                var toPay = completed.Where((_, idx) => idx % 2 == 0).ToList();
                var n = 1;
                foreach (var appointment in toPay)
                {
                    context.Payments.Add(new Payment
                    {
                        AppointmentId = appointment.Id,
                        Amount = servicePrices.TryGetValue(appointment.ServiceId, out var price) ? price : 50m,
                        Method = "PayPal",
                        Status = PaymentStatus.Paid,
                        TransactionRef = $"SEED-CAPTURE-{n:D4}",
                        PayPalOrderId = $"SEED-ORDER-{n:D4}",
                        CreatedAt = appointment.EndTime.AddMinutes(10)
                    });
                    n++;
                }
                await context.SaveChangesAsync();
            }

            if (!await context.Reviews.AnyAsync())
            {
                var reviews = new (int Index, int Rating, string Comment)[]
                {
                    (0, 5, "Izuzetno ljubazno osoblje i bezbolan pregled. Sve pohvale!"),
                    (1, 4, "Čišćenje je obavljeno brzo i profesionalno."),
                    (3, 5, "Doktor je detaljno objasnio svaki korak. Preporučujem."),
                    (5, 4, "Kratko čekanje i uredna ordinacija."),
                };

                foreach (var (index, rating, comment) in reviews)
                {
                    if (index >= completed.Count)
                        continue;

                    var appointment = completed[index];
                    context.Reviews.Add(new Review
                    {
                        AppointmentId = appointment.Id,
                        PatientId = appointment.PatientId,
                        DoctorId = appointment.DoctorId,
                        Rating = rating,
                        Comment = comment,
                        CreatedAt = appointment.EndTime.AddDays(1)
                    });
                }
                await context.SaveChangesAsync();
            }
        }

        private static async Task SeedOrdersAndInteractionsAsync(SOHDbContext context)
        {
            var products = await context.Products.OrderBy(p => p.Id).ToListAsync();
            if (products.Count == 0)
                return;

            var now = DateTime.UtcNow;

            if (!await context.Orders.AnyAsync())
            {
                var orders = new (int PatientId, int ProductIndex, int Quantity, int DaysAgo)[]
                {
                    (PatientAmel, 0, 1, 22),
                    (PatientAmel, 3, 2, 20),
                    (PatientAmel, 6, 1, 6),
                    (PatientTest, 1, 1, 15),
                    (PatientTest, 4, 1, 12),
                    (PatientMobile, 3, 1, 9),
                    (PatientMobile, 8, 2, 7),
                    (PatientMobile, 6, 1, 2),
                };

                foreach (var (patientId, productIndex, quantity, daysAgo) in orders)
                {
                    var product = products[productIndex % products.Count];
                    context.Orders.Add(new Order
                    {
                        PatientId = patientId,
                        ProductId = product.Id,
                        Quantity = quantity,
                        TotalAmount = product.Price * quantity,
                        CreatedAt = now.AddDays(-daysAgo)
                    });
                }
                await context.SaveChangesAsync();
            }

            if (!await context.ProductInteractions.AnyAsync())
            {
                // Views + opened details feed the recommender's personal signals.
                var interactions = new (int UserId, int ProductIndex, ProductInteractionKind Kind, int DaysAgo)[]
                {
                    (PatientAmel, 0, ProductInteractionKind.View, 23),
                    (PatientAmel, 0, ProductInteractionKind.DetailOpened, 23),
                    (PatientAmel, 3, ProductInteractionKind.View, 21),
                    (PatientAmel, 4, ProductInteractionKind.View, 5),
                    (PatientTest, 1, ProductInteractionKind.View, 16),
                    (PatientTest, 1, ProductInteractionKind.DetailOpened, 16),
                    (PatientTest, 7, ProductInteractionKind.View, 4),
                    (PatientMobile, 3, ProductInteractionKind.View, 10),
                    (PatientMobile, 3, ProductInteractionKind.DetailOpened, 9),
                    (PatientMobile, 8, ProductInteractionKind.View, 8),
                    (PatientMobile, 9, ProductInteractionKind.View, 3),
                    (PatientMobile, 6, ProductInteractionKind.View, 1),
                };

                foreach (var (userId, productIndex, kind, daysAgo) in interactions)
                {
                    context.ProductInteractions.Add(new ProductInteraction
                    {
                        UserId = userId,
                        ProductId = products[productIndex % products.Count].Id,
                        Kind = kind,
                        CreatedAt = now.AddDays(-daysAgo)
                    });
                }
                await context.SaveChangesAsync();
            }
        }

        private static async Task SeedHygieneAsync(SOHDbContext context)
        {
            if (await context.HygieneTrackers.AnyAsync())
                return;

            var today = DateTime.UtcNow.Date;
            foreach (var patientId in new[] { PatientAmel, PatientMobile })
            {
                for (var daysAgo = 1; daysAgo <= 5; daysAgo++)
                {
                    context.HygieneTrackers.Add(new HygieneTracker
                    {
                        PatientId = patientId,
                        Date = today.AddDays(-daysAgo),
                        BrushesCount = daysAgo % 3 == 0 ? 1 : 2
                    });
                }
            }
            await context.SaveChangesAsync();
        }

        private static async Task SeedNotificationsAsync(SOHDbContext context)
        {
            if (await context.UserNotifications.AnyAsync())
                return;

            var now = DateTime.UtcNow;
            context.UserNotifications.AddRange(
                new UserNotification
                {
                    UserId = PatientMobile,
                    Title = "Termin zakazan",
                    Body = "Vaš zahtjev za termin je evidentiran. Obavijestit ćemo vas o promjenama njegovog statusa.",
                    CreatedAt = now.AddDays(-9),
                    ReadAt = now.AddDays(-9).AddHours(2)
                },
                new UserNotification
                {
                    UserId = PatientMobile,
                    Title = "Status termina promijenjen",
                    Body = "Vaš termin je promijenio status: Na čekanju → Prihvaćen.",
                    CreatedAt = now.AddDays(-8)
                },
                new UserNotification
                {
                    UserId = PatientAmel,
                    Title = "Uplata primljena",
                    Body = "Vaša uplata od 50.00 KM za termin je potvrđena.",
                    CreatedAt = now.AddDays(-24)
                });
            await context.SaveChangesAsync();
        }

        private static async Task SeedActivityLogsAsync(SOHDbContext context)
        {
            if (await context.ActivityLogs.AnyAsync())
                return;

            var now = DateTime.UtcNow;
            var actions = new (string Action, string EntityName, string EntityId, int UserId, string Username, int HoursAgo)[]
            {
                ("UserRegistered", "User", "6", PatientMobile, "mobile", 240),
                ("AppointmentCreated", "Appointment", "1", PatientAmel, "user", 200),
                ("AppointmentUpdated", "Appointment", "1", DoctorAdil, "admin2", 190),
                ("AppointmentCreated", "Appointment", "8", PatientTest, "user2", 60),
                ("AppointmentCancelled", "Appointment", "17", PatientAmel, "user", 30),
            };

            foreach (var (action, entityName, entityId, userId, username, hoursAgo) in actions)
            {
                context.ActivityLogs.Add(new ActivityLog
                {
                    Action = action,
                    EntityName = entityName,
                    EntityId = entityId,
                    UserId = userId,
                    Username = username,
                    CreatedAt = now.AddHours(-hoursAgo)
                });
            }
            await context.SaveChangesAsync();
        }
    }
}
