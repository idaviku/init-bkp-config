#!/bin/bash
#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Nombre del script: bkp4dummies.sh 
# Descripción: Respaldo optimizado y modular para dotfiles integrados con Vim.
# Admite procesamiento por archivo individual y rotación segura.
# Autor: @idaviku
# Fecha de creación: 2024-10-26
# Última modificación: 2024-10-26
# -----------------------------------------------------------------------------


set -euo pipefail

# --- Configuración ---
TARGET_FILE="${1:-}"
BACKUP_DIR="$HOME/.local/share/bkp4dummies"

# Validar que se haya pasado un archivo como argumento
if [ -z "$TARGET_FILE" ]; then
    echo "[ERROR] No se especificó ningún archivo para respaldar." >&2
    exit 1
fi

# Resolver la ruta absoluta del archivo original
TARGET_PATH=$(realpath "$TARGET_FILE")

# Validar que el archivo realmente exista
if [ ! -f "$TARGET_PATH" ]; then
    exit 0
fi

mkdir -p "$BACKUP_DIR"

FILE_NAME=$(basename "$TARGET_PATH")
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
NEW_BACKUP="$BACKUP_DIR/${FILE_NAME}_${TIMESTAMP}.bak"

# Buscar el último respaldo que se haya generado para este archivo específico
LAST_BACKUP=$(ls -t "$BACKUP_DIR/${FILE_NAME}_"*.bak 2>/dev/null | head -n 1 || true)

if [ -n "$LAST_BACKUP" ]; then
    if cmp -s "$TARGET_PATH" "$LAST_BACKUP"; then
        exit 0
    fi
fi

# Crear el nuevo punto de restauración de manera atómica
cp -p "$TARGET_PATH" "$NEW_BACKUP"

# --- Gobernanza de Datos: Retención y Limpieza ---
# Mantiene solo los últimos 5 respaldos de este archivo para evitar llenar el almacenamiento.
(
    cd "$BACKUP_DIR"
    ls -t "${FILE_NAME}_"*.bak 2>/dev/null | tail -n +6 | xargs rm -f -- 2>/dev/null || true
)
