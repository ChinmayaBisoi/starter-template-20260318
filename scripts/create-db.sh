#!/usr/bin/env bash
# Create local Postgres database: user + database.
# Run as a superuser (e.g. postgres) or with peer auth. Prompts for username, password, dbname.

set -e

read -p "Database username: " username
[[ -z "$username" ]] && { echo "Username required."; exit 1; }

read -r -p "Database user password: " userpassword
[[ -z "$userpassword" ]] && { echo "Password required."; exit 1; }

read -p "Database name: " dbname
[[ -z "$dbname" ]] && { echo "Database name required."; exit 1; }

# Escape single quotes in password for SQL
userpassword_esc="${userpassword//\'/\'\'}"

echo "Creating user and database..."
psql -v ON_ERROR_STOP=1 -c "CREATE USER $username WITH PASSWORD '$userpassword_esc' CREATEDB;"
psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE $dbname WITH OWNER = $username;"

echo "Done. Connection: LOCAL_DATABASE_URL=postgresql://$username:$userpassword_esc@${PGHOST:-localhost}:${PGPORT:-5432}/$dbname"
