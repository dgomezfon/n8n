#!/bin/bash
set -e

echo "🚀 Initializing database..."

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

DO
\$do\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = '${POSTGRES_NON_ROOT_USER}'
   ) THEN
      CREATE ROLE ${POSTGRES_NON_ROOT_USER} LOGIN PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';
   END IF;
END
\$do\$;

GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
GRANT ALL ON SCHEMA public TO ${POSTGRES_NON_ROOT_USER};

EOSQL

echo "✅ Database initialized"
