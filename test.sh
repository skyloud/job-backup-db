set -e
docker compose up minio mongodb webhook mariadb postgres -d

echo "Waiting for databases to be ready..."
sleep 15

echo "Running tests..."
docker compose up mongodb-backup
docker compose up mariadb-backup
docker compose up postgres-backup
docker compose up postgres-dump-all-backup

echo "Done"