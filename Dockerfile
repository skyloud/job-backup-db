FROM alpine:3.9.6

ENV BAGCLI_RETENTION_TIME=7d
ENV BAGCLI_BUCKET_PATH=backup
ENV BAGCLI_DATABASE_HOST=localhost
ENV BAGCLI_DATABASE_PORT=5432
ENV BAGCLI_DATABASE_OPTIONS="-c work_mem=100MB"

WORKDIR /backup-cli

RUN apk add --no-cache --update postgresql-client

COPY --from=minio/mc /usr/bin/mc /usr/bin/mc

COPY main.sh /usr/bin/backup
COPY src/ ./

RUN chmod +x /usr/bin/backup \
  && chmod +x -R ./commands

ENTRYPOINT [ "backup" ]

CMD [ "postgres" ]