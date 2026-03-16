#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Copy everything
COPY ./source ./
ENTRYPOINT ["dotnet", "JessesNewWeb.dll"]
