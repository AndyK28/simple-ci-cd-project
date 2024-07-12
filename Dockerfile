# Use the appropriate .NET SDK image as a build environment
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory
WORKDIR /app

# Copy the solution file and restore dependencies
COPY ./pipeline-config.sln ./
RUN dotnet restore

# Copy the project files and build the application
COPY . ./
RUN dotnet build -c Release --no-restore

# Run tests (if any, adjust this accordingly)
RUN dotnet test --no-build

# Publish the application
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Expose port
EXPOSE 80

# Command to run the application
ENTRYPOINT ["dotnet", "SimpleApp.dll"]
