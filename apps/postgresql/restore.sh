#!/bin/bash

DB=$1

PASSWORD="mysecurepassword"

docker run --rm \
  -e PGPASSWORD=${PASSWORD} \
  -v $PWD/backup:/pgsql-tmp \
  postgres:18 \
  bash -c "psql -U postgres -h 192.168.13.13 -d ${DB} -f /pgsql-tmp/${DB}.sql"
