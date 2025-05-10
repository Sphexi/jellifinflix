# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnv

FROM alpine:3.21
VOLUME /media
RUN apk add --no-cache bash figlet curl
COPY . /app

RUN chmod +x /app/entry.sh
RUN chmod +x /app/cron.sh
RUN chmod -R a+x /app/crontab

ENTRYPOINT ["sh","/app/cron.sh"]
