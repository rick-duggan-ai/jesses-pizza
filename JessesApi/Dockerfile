#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["JessesApi/JessesApi.csproj", "JessesApi/"]
COPY ["JessesPizza.Core/JessesPizza.Core.csproj", "JessesPizza.Core/"]
COPY ["JessesPizza.Data/JessesPizza.Data.csproj", "JessesPizza.Data/"]
COPY ["JessesPizza.App.Core/JessesPizza.MobileApp.Core.csproj", "JessesPizza.App.Core/"]

RUN dotnet restore "JessesApi/JessesApi.csproj"
COPY . .
WORKDIR "/src/JessesApi"
RUN dotnet build "JessesApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "JessesApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
RUN mkdir /app/JessesAPILogs
VOLUME /app/JessesAPILogs
RUN mkdir /app/PrivacyPolicy
VOLUME /app/PrivacyPolicy
COPY JessesApi/PrivacyPolicy/Privacy.txt /app/PrivacyPolicy
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "JessesApi.dll"]
