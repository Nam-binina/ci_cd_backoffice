#!/bin/bash
set -euo pipefail

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-ci_cd}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"

MYSQL_ARGS=("-h" "$DB_HOST" "-P" "$DB_PORT" "-u" "$DB_USER" "$DB_NAME" "--default-character-set=utf8mb4")

if [[ -n "$DB_PASSWORD" ]]; then
  export MYSQL_PWD="$DB_PASSWORD"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

shopt -s nullglob
SQL_FILES=("$SCRIPT_DIR"/*.sql)
shopt -u nullglob
DONEE_FILE="$SCRIPT_DIR/donee.sql"

if [[ ${#SQL_FILES[@]} -eq 0 ]]; then
  echo "Aucun fichier .sql trouvé dans $SCRIPT_DIR"
  exit 0
fi

for sql_file in "${SQL_FILES[@]}"; do
  if [[ "$sql_file" == "$DONEE_FILE" ]]; then
    continue
  fi
  echo "▶ Exécution: $(basename "$sql_file")"
  mysql "${MYSQL_ARGS[@]}" < "$sql_file"
done

if [[ -f "$DONEE_FILE" ]]; then
  echo "▶ Exécution: $(basename "$DONEE_FILE") (dernier)"
  mysql "${MYSQL_ARGS[@]}" < "$DONEE_FILE"
fi

echo "✅ Tous les scripts .sql ont été exécutés."
