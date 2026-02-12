FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY Backend.slnx ./
COPY src/Backend.Api/Backend.Api.csproj src/Backend.Api/
COPY tests/Backend.Tests/Backend.Tests.csproj tests/Backend.Tests/
RUN dotnet restore

COPY . .
RUN dotnet build Backend.slnx -c Release --no-restore

FROM build AS test
RUN dotnet test tests/Backend.Tests/Backend.Tests.csproj -c Release --no-build --filter "Category!=Integration"

FROM build AS publish
RUN dotnet publish src/Backend.Api/Backend.Api.csproj -c Release --no-build -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
# COPY from test stage ensures tests must pass before the image is built
COPY --from=test /src/tests/Backend.Tests/TestResults* /tmp/
COPY --from=publish /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "Backend.Api.dll"]
