# Go --------------------------------------------------------------------------
FROM python:3.11-alpine

RUN apk update && apk add ffmpeg ca-certificates curl wget gnutls --no-cache

RUN pip install "yt-dlp[default,curl-cffi,mutagen,pycryptodomex,phantomjs,secretstorage]"

WORKDIR /app

COPY --from=build /usr/src/yt-dlp-webui/yt-dlp-webui /app

ENV JWT_SECRET=secret

EXPOSE 3033

ENTRYPOINT [ "./yt-dlp-webui", "--out", "/downloads", "--conf", "/config/config.yml", "--db", "/config/local.db" ]
