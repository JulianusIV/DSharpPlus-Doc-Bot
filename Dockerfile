FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build
WORKDIR /src

COPY ./ /src
RUN dotnet restore -r linux-musl-x64 && dotnet publish -c Release -r linux-musl-x64 --no-restore --self-contained -p:PublishSingleFile=true -p:EnableCompressionInSingleFile=true -p:DebugType=embedded -f net7.0

FROM alpine:latest
WORKDIR /src

COPY --from=build /src/bin/Release/net7.0/linux-musl-x64/publish /src
RUN apk upgrade --update-cache --available && apk add openssl libstdc++ icu-libs && rm -rf /var/cache/apk/*

ENTRYPOINT /src/DocBot