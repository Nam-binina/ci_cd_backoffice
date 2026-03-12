#!/bin/bash
set -euo pipefail

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-ci_cd}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"
MYSQL_BIN="${MYSQL_BIN:-/opt/lampp/bin/mysql}"
USE_SUDO="${USE_SUDO:-true}"

if [[ "$USE_SUDO" == "true" ]]; then
  MYSQL_CMD=(sudo "$MYSQL_BIN")
else
  MYSQL_CMD=("$MYSQL_BIN")
fi

MYSQL_ARGS=(-h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME")

if [[ -n "$DB_PASSWORD" ]]; then
  export MYSQL_PWD="$DB_PASSWORD"
fi

echo "Récupération des tables..."

TABLES=$("${MYSQL_CMD[@]}" "${MYSQL_ARGS[@]}" -Nse \
"SELECT table_name FROM information_schema.tables WHERE table_schema='${DB_NAME}'")

if [[ -z "$TABLES" ]]; then
  echo "Aucune table trouvée."
  exit 0
fi

SQL="SET FOREIGN_KEY_CHECKS=0;"

for table in $TABLES
do
  SQL+="DELETE FROM \`$table\`;"
  echo "Table vidée: $table"
done

SQL+="SET FOREIGN_KEY_CHECKS=1;"

echo "$SQL" | "${MYSQL_CMD[@]}" "${MYSQL_ARGS[@]}"

echo "✅ Toutes les tables ont été vidées."