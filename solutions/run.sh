#!/bin/bash
CONTAINER=$1
DATABASE=$2
USER=$3

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

if ls "$SCRIPT_DIR"/*.sql >/dev/null 2>&1; then
    for file in "$SCRIPT_DIR"/*.sql
    do
        echo "Выполняем задание $(basename "$file")..."
        cat "$file" | docker exec -i "$CONTAINER" psql -U "$USER" -d "$DATABASE"
        if [ $? -eq 0 ]; then
            echo "Успешно выполнен $(basename "$file")"
            echo "----------"
        else
            echo "Ошибка при выполнении $(basename "$file")"
            exit 1
        fi
    done
    echo "Готово!"
else
    echo "Ошибка: в директории $SCRIPT_DIR нет файлов с расширением .sql"
    exit 1
fi