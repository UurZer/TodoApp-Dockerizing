#build phase
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as build

WORKDIR /source
COPY /. ./

RUN dotnet restore

RUN dotnet build TodoApi.csproj -c Release

RUN dotnet publish TodoApi.csproj -c Release -o /src/output

#Run phase
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine AS runtime

RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

RUN apk add libgdiplus --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
RUN apk add libc-dev --no-cache

COPY --from=build /src/output .

ENTRYPOINT [ "dotnet","TodoApi.dll" ]