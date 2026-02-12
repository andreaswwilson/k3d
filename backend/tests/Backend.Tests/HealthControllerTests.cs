using System.Net;
using Backend.Tests.Fixtures;

namespace Backend.Tests;

public class HealthControllerTests(CustomWebApplicationFactory factory)
    : IClassFixture<CustomWebApplicationFactory>
{
    private readonly HttpClient _client = factory.CreateClient();

    [Fact]
    public async Task Get_ReturnsHelloFromBackend()
    {
        var response = await _client.GetAsync("/api/healthcheck");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        var content = await response.Content.ReadAsStringAsync();
        Assert.NotEmpty(content);
    }
}
