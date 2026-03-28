# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run Commands

```bash
# Build entire solution
dotnet build JessesPizza.sln

# Build individual projects
dotnet build JessesApi/JessesApi.csproj
dotnet build JessesNewWeb/JessesNewWeb.csproj
dotnet build JessesPizza.WebApp/JessesPizza.WebApp.csproj

# Run projects locally
dotnet run --project JessesApi
dotnet run --project JessesNewWeb

# Run tests
dotnet test JessesPizza.Data.Tests/JessesPizza.Data.Tests.csproj
dotnet test JessesPizza.WebApp.Tests/JessesPizza.WebApp.Tests.csproj
dotnet test  # runs all test projects

# Run a single test
dotnet test --filter "FullyQualifiedName~TestClassName.TestMethodName"
```

## Architecture Overview

This is a multi-project .NET solution for Jesse's Pizza, a pizza ordering and kitchen management system. Projects target different .NET versions—be careful not to mix incompatible APIs.

### Active Deployable Services

- **JessesApi** (.NET Core 3.1) — REST API serving mobile apps and other clients. Uses JWT auth, MongoDB for data, SignalR (`PizzaHub`) for real-time updates, Swagger at `/swagger`, API versioning via `X-Version` header, and IP rate limiting.
- **JessesPizza.WebApp** (.NET Core 3.1) — Blazor Server web application (uses Radzen.Blazor and Telerik components). Has a local SQLite `UserDatabase.db` and connects to the API/MongoDB.
- **JessesNewWeb** (.NET 6.0) — MVC web app that replaced the original KDS mobile app as an emergency substitute (Feb 2023). Uses MongoDB directly and Flurl for HTTP calls. Requires `API_TOKEN` environment variable (a JWT from the API's `/api/Auth/UserLogin` endpoint, expires every 6 months).

### Shared Libraries

- **JessesPizza.Core** (netstandard2.0) — Domain models shared across all projects. References MongoDB.Bson and sqlite-net-pcl.
- **JessesPizza.Data** — Data access layer used by WebApp and API.
- **JessesPizza.App.Core** (MobileApp.Core) — Core library for Xamarin mobile apps.

### Legacy/Mobile (Xamarin)

- **JessesPizza.Android / JessesPizza.iOS** — Customer-facing Xamarin mobile app.
- **JessesPizzaKitchen / JessesPizzaKitchen.Android / JessesPizzaKitchen.iOS** — Kitchen Display System (KDS) Xamarin app. Stopped working Feb 2023; replaced by JessesNewWeb.
- **JessesPizza.MobileAppService** — Backend for the legacy mobile app (pre-JessesApi).

### Dependency Chain

```
JessesPizza.App.Core (MobileApp.Core)
  └── JessesPizza.Core
        └── JessesPizza.App.Core
JessesPizza.Data
JessesApi        → JessesPizza.Core, JessesPizza.Data, JessesPizza.App.Core
JessesPizza.WebApp → JessesPizza.Core, JessesPizza.Data
JessesNewWeb     → (standalone, uses MongoDB.Driver + Flurl)
```

### Databases

- **MongoDB** — Primary data store (menu items, orders, transactions). Connection configured in `MongoDbSettings` section of appsettings.
- **SQL Server** — Used by JessesApi for ASP.NET Identity (`AspNetCore.Identity.MongoDbCore` is also present—Identity may have been migrated to MongoDB).
- **SQLite** — Local database in JessesPizza.WebApp (`UserDatabase.db`), used via sqlite-net-pcl in Core.

### Tests

xunit with FluentAssertions. Test projects target netcoreapp3.1:
- `JessesPizza.Data.Tests` — Tests for the data layer
- `JessesPizza.WebApp.Tests` — Tests for the web app (also references SendGrid)

## Deployment

Deployed to **AWS Elastic Beanstalk** as a multi-container Docker environment via `Dockerrun.aws.json`. Two containers run side by side:

| Container | ECR Repo | Port | Entry Point |
|-----------|----------|------|-------------|
| web-app-service | `jesses-pizza-web` | 5001→80 | JessesPizza.WebApp.dll |
| mobile-app-service | `jesses-pizza-mobile` | 5000→80 | JessesApi.dll |

Note: Despite the name "mobile-app-service", the `jesses-pizza-mobile` ECR repo runs **JessesApi**.

JessesNewWeb (KDS replacement) is deployed separately to its own Elastic Beanstalk environment:
```bash
dotnet publish
cd bin/Debug/net6.0/publish
zip -r ../../../../pkg.zip .
# Upload zip as new application version in Elastic Beanstalk
```

### Environment Variables

- `API_TOKEN` — Auth token for JessesNewWeb KDS app (obtain via `/api/Auth/UserLogin`)
- `SMTP_ADDRESS`, `SMTP_USERNAME`, `SMTP_PASSWORD` — Email sending config (defaults to Sendinblue relay)

### Docker Build (API example)

```bash
docker build -f JessesApi/Dockerfile -t jesses-api .
```

Dockerfiles exist at the root for each deployable: JessesNewWeb, JessesPizza.WebApp, JessesPizza.MobileAppService, and JessesApi.

### Local Development with Docker Compose

A `docker-compose.yml` provides a local multi-container setup with MongoDB, Mongo Express, MobileAppService, and WebApp. A `deploy.sh` script handles AWS ECR push and Elastic Beanstalk deployment.

## Important: Verify Against the Codebase

When in doubt, search the existing codebase for how things actually work. Do not guess at API route paths, response shapes, or data models — read the controller source code. C# method names often differ from the `[Route()]` attributes that define the actual HTTP paths (e.g., the method `PostTransactionWithCreditCard` is routed as `PostTransaction`). Always check the `[HttpGet]`/`[HttpPost]` and `[Route()]` attributes for the real endpoint paths.

## Working Style

Work in parallel as much as possible. Use git worktrees and branches to separate work.

## Key Conventions

- API controllers use `[ApiVersion]` attributes and Swagger annotations (`[SwaggerTag]`)
- Logging uses Serilog with structured logging (CompactJsonFormatter)
- The API serves Swagger docs at `/swagger/v1/swagger.json`
- SignalR hub at `/chatHub` (PizzaHub) for real-time kitchen/order updates
- Flurl is used for HTTP client calls in WebApp and JessesNewWeb (not HttpClient directly)
