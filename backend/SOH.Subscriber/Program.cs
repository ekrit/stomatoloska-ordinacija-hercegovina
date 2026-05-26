using DotNetEnv;
using SOH.Subscriber.Interfaces;
using SOH.Subscriber.Services;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

// Pick up SMTP and RabbitMQ secrets from a local .env when running outside
// Docker. In Docker the variables are injected by the orchestrator, in
// which case NoClobber keeps the explicit env winning over the file.
Env.NoClobber().TraversePath().Load();

var builder = Host.CreateDefaultBuilder(args)
    .ConfigureServices((hostContext, services) =>
    {
        services.AddSingleton<IEmailSenderService, EmailSenderService>();
        services.AddHostedService<BackgroundWorkerService>();
    });

var host = builder.Build();
await host.RunAsync();
