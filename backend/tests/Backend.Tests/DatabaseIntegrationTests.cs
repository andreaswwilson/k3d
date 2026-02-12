using Backend.Tests.Fixtures;
using FluentAssertions;
using Npgsql;

namespace Backend.Tests;

[Trait("Category", "Integration")]
public class DatabaseIntegrationTests : IClassFixture<PostgresFixture>
{
    private readonly PostgresFixture _postgres;

    public DatabaseIntegrationTests(PostgresFixture postgres)
    {
        _postgres = postgres;
    }

    [Fact]
    public async Task PostgresContainer_IsReachable()
    {
        await using var connection = new NpgsqlConnection(_postgres.ConnectionString);
        await connection.OpenAsync();

        await using var command = new NpgsqlCommand("SELECT 1", connection);
        var result = await command.ExecuteScalarAsync();

        result.Should().Be(1);
    }
}
