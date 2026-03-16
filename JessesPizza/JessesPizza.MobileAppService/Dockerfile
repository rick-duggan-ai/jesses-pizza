#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["JessesPizza/JessesPizza.MobileAppService/JessesPizza.MobileAppService.csproj", "JessesPizza/JessesPizza.MobileAppService/"]
COPY ["JessesPizza.App.Core/JessesPizza.App.Core.csproj", "JessesPizza.App.Core/"]
COPY ["JessesPizza.Core/JessesPizza.Core.csproj", "JessesPizza.Core/"]
COPY ["JessesPizza.Data/JessesPizza.Data.csproj", "JessesPizza.Data/"]
COPY ./JessesPizza/JessesPizza.MobileAppService/nuget.config .
RUN dotnet restore "JessesPizza/JessesPizza.MobileAppService/JessesPizza.MobileAppService.csproj"
COPY . .
WORKDIR "/src/JessesPizza/JessesPizza.MobileAppService"
RUN dotnet build "JessesPizza.MobileAppService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "JessesPizza.MobileAppService.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
RUN mkdir /app/JessesAPILogs
VOLUME /app/JessesAPILogs
RUN mkdir /app/PrivacyPolicy
VOLUME /app/PrivacyPolicy
COPY ./JessesPizza/JessesPizza.MobileAppService/PrivacyPolicy/Privacy.txt /app/PrivacyPolicy
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "JessesPizza.MobileAppService.dll"]