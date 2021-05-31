# Introduction

This image is used for automatic database backup on any S3 endpoint.

You can easily setup a cron on a kubernetes cluster for any kind of databases.

Image : `skyloud/job-backup-db` available on [docker hub](https://hub.docker.com/r/skyloud/job-backup-db) !

👉 https://hub.docker.com/r/skyloud/job-backup-db

| Kind         |    Status     |
| ------------ | :-----------: |
| **Postgres** |    ✔ Done     |
| **Mysql**    | ⚡️ In progress |
| **MongoDB**  | ⚡️ In progress |

You can help us to contribute on our repos 🚀

# Configure S3 

You'll need to setup a policy for a newly created user which will be used for this backup.

Copy this policy in `postgres-prod-backup-policy.json` :

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::project/",
        "arn:aws:s3:::project/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::project/prod/postgres/*",
        "arn:aws:s3:::project/prod/postgres"
      ]
    }
  ]
}
```

Configure your policy on minio :

```bash
mc admin policy add s3 project-prod-postgres-policy s3-postgres-prod-policy.json
mc admin user add s3 project-prod-postgres-user my_very_strong_key_uuid_v4
mc admin policy set s3 project-prod-postgres-policy user=project-prod-postgres-user
```

# How to use

## With docker

```bash
docker run --rm -it \
  -e BAGCLI_DATABASE_HOST="postgres.namespace.svc.cluster.local" \
  -e BAGCLI_DATABASE_USER="postgres" \
  -e BAGCLI_DATABASE_PASS="db_password" \
  -e BAGCLI_BUCKET_PATH="bucket/prod/postgres" \
  -e MC_HOST_s3="https://user:password@minio:9000" \
  skyloud/job-backup-db postgres database-name
```

## With kubernetes

> **Note :** Please update the file `kubernetes.yaml` with your own values.

```bash
kubectl apply -f kubernetes.yaml
```

Enjoy !
