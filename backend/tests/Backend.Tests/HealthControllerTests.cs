using System.Net;
using Backend.Tests.Fixtures;
using FluentAssertions;

namespace Backend.Tests;

public class HealthControllerTests : IClassFixture<CustomWebApplicationFactory>
{
    private readonly HttpClient _client;

    public HealthControllerTests(CustomWebApplicationFactory factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task Get_ReturnsHelloFromBackend()
    {
        var response = await _client.GetAsync("/api/healthcheck");

        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var content = await response.Content.ReadAsStringAsync();
        content.Should().Be("hello from backend");
    }
}
