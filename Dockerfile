FROM alpine:3.14

ENV BAGCLI_RETENTION_TIME=7d
ENV BAGCLI_BUCKET_PATH=backup
ENV BAGCLI_DATABASE_HOST=localhost
ENV BAGCLI_DATABASE_PORT=5432
ENV BAGCLI_DATABASE_OPTIONS="-c work_mem=100MB"
ENV BAGCLI_DATABASE_NAME=test
ENV BAGCLI_DATABASE_URI=mongodb://mongoadmin:secret@mongodb-arbiter-0.mongodb-arbiter-headless.database:27017,mongodb-0.mongodb-headless.database:27017,mongodb-1.mongodb-headless.database:27017/mongodb_d_test?replicaSet=rs0&authSource=admin&retryWrites=true&w=majority

WORKDIR /backup-cli

RUN apk add --no-cache --update postgresql-client mariadb-client mongodb-tools bash

COPY --from=minio/mc /usr/bin/mc /usr/bin/mc

COPY main.sh /usr/bin/backup
COPY src/ ./

RUN chmod +x /usr/bin/backup \
  && chmod +x -R ./commands

ENTRYPOINT [ "backup" ]

CMD [ "postgres" ]