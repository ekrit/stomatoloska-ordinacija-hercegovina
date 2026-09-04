FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5130
ENV ASPNETCORE_URLS=http://+:5130

# ML.NET Matrix Factorization (the recommender) ships a native OpenMP library
# that needs libgomp1 at runtime; the aspnet image does not include it. Without
# it training throws and the recommender silently falls back to popularity.
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgomp1 \
    && rm -rf /var/lib/apt/lists/*

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .

FROM build AS publish
RUN dotnet publish "SOH.WebAPI/SOH.WebAPI.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
COPY SOH.WebAPI/Assets ./Assets

ENTRYPOINT ["dotnet", "SOH.WebAPI.dll"]