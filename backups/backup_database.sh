#!/bin/bash

DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="/c/Users/USER PC/Documents/backups"
DB_NAME="student_records"
PG_USER="postgres"
PG_PASSWORD="postgres"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Export password so pg_dump can use it
export PGPASSWORD=$PG_PASSWORD

# Run pg_dump
"/c/Program Files/PostgreSQL/17/bin/pg_dump.exe" -U $PG_USER -F c -b -v -f "$BACKUP_DIR/${DB_NAME}_${DATE}.backup" $DB_NAME

# Keep only the last 7 backups
ls -t "$BACKUP_DIR/${DB_NAME}_*.backup" | tail -n +8 | xargs rm -f 2>/dev/null

echo "Backup completed: $BACKUP_DIR/${DB_NAME}_${DATE}.backup"
