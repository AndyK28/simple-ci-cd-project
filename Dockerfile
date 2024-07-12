# Use the ASP.NET Core runtime as a base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app

# Use the SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the solution file and restore dependencies
COPY ./pipeline-config.sln ./
COPY ./SimpleApp/SimpleApp.csproj ./SimpleApp/
COPY ./SimpleApp.Tests/SimpleApp.Tests.csproj ./SimpleApp.Tests/
RUN dotnet restore

# Copy the remaining project files and build the application
COPY . .
WORKDIR /src/SimpleApp
RUN dotnet build --configuration Release --no-restore
RUN dotnet publish --configuration Release --no-restore -o /app

# Copy the build artifacts to the runtime image
FROM runtime AS final
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "SimpleApp.dll"]
