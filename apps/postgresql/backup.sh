#!/bin/bash

mkdir -p backup

DB=$1

PASSWORD="mysecurepassword"

docker run --rm \
  -e PGPASSWORD=${PASSWORD} \
  -v $PWD/backup:/pgsql-tmp \
  postgres:18 \
  bash -c "pg_dump -U postgres -h 192.168.13.13 -d ${DB} -F p -f /pgsql-tmp/${DB}.sql"
