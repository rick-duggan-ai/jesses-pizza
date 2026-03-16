#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["JessesPizza.WebApp/JessesPizza.WebApp.csproj", "JessesPizza.WebApp/"]
COPY ["JessesPizza.WebApp/nuget.config", "JessesPizza.WebApp/"]
COPY ["JessesPizza.Core/JessesPizza.Core.csproj", "JessesPizza.Core/"]
COPY ["JessesPizza.App.Core/JessesPizza.MobileApp.Core.csproj", "JessesPizza.App.Core/"]
COPY ["JessesPizza.Data/JessesPizza.Data.csproj", "JessesPizza.Data/"]
COPY JessesPizza.WebApp/nuget.config .

RUN dotnet restore "JessesPizza.WebApp/JessesPizza.WebApp.csproj"
COPY . .
WORKDIR "/src/JessesPizza.WebApp"
RUN dotnet build "JessesPizza.WebApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "JessesPizza.WebApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
RUN mkdir /app/database
RUN mkdir /app/JessesWebLogs
RUN mkdir /app/test
COPY UserDatabase.db /app/database 

VOLUME /app/database
VOLUME /app/wwwroot/JessesImages
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "JessesPizza.WebApp.dll"]