# Go --------------------------------------------------------------------------
FROM golang AS build

WORKDIR /usr/src/yt-dlp-webui

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o yt-dlp-webui
# -----------------------------------------------------------------------------

# Runtime ---------------------------------------------------------------------
FROM python:3.13.2-alpine3.21

RUN apk update && \
    apk add ffmpeg ca-certificates curl wget gnutls --no-cache && \
    pip install "yt-dlp[default,curl-cffi,mutagen,pycryptodomex,phantomjs,secretstorage]"

WORKDIR /app

COPY --from=build /usr/src/yt-dlp-webui/yt-dlp-webui /app

ENV JWT_SECRET=secret

EXPOSE 3033

ENTRYPOINT [ "./yt-dlp-webui", "--out", "/downloads", "--conf", "/config/config.yml", "--db", "/config/local.db" ]
