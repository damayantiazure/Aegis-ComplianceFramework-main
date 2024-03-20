#nullable enable

using AutoFixture.AutoMoq;
using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Linq;

namespace Rabobank.Compliancy.Functions.Sm9Changes.Tests;

public class StartupTests
{
    private readonly Fixture _fixture = new();

    public StartupTests()
    {
        _fixture.Customize(new AutoMoqCustomization());

        Environment.SetEnvironmentVariable("azdoPat", _fixture.Create<string>());
        Environment.SetEnvironmentVariable("itsmEndpointKong", "http://localhost");
        Environment.SetEnvironmentVariable("itsmApiResourceKong", $"{_fixture.Create<Guid>()}");
        Environment.SetEnvironmentVariable("globalManagedIdentityClientId", _fixture.Create<string>());
    }

    [Fact]
    public void TestDependencyInjectionResolve()
    {
        // Arrange
        var services = new ServiceCollection();
        services.AddLogging();

        var builder = new Mock<IFunctionsHostBuilder>();
        builder
            .Setup(hostBuilder => hostBuilder.Services)
            .Returns(services);

        var functions = typeof(Startup)
            .Assembly
            .GetTypes()
            .Where(type => Array.Exists(type.GetMethods(), method =>
                method.GetCustomAttributes(typeof(FunctionNameAttribute), false).Any() &&
                !method.IsStatic))
            .ToList();

        functions.ForEach(function => services.AddScoped(function));

        Startup.RegisterServices(services, CreateConfig());
        var provider = services.BuildServiceProvider();

        // Act
        var actual = () => functions.ForEach(function => provider.GetService(function));

        // Assert
        actual.Should().NotThrow();
    }

    private static IConfiguration CreateConfig()
    {
        var configBuilder = new ConfigurationBuilder();
        configBuilder.AddJsonFile("logsettings.development.json");
        return configBuilder.Build();
    }
}