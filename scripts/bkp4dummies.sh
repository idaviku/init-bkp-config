#!/bin/bash
# -----------------------------------------------------------------------------
# Nombre del script: bkp4dummies.sh 
# Descripción: Script para mantener un punto anterior al actual de algunos
# archivos de configuracion, se usa en conjunto con vim para facilitar la
# gestion de las copias.
# Autor: @idaviku
# Fecha de creación: 2024-10-26
# Última modificación: 2024-10-26
# -----------------------------------------------------------------------------


files=("$HOME/.vimrc" "$HOME/.zshrc" "$HOME/.tmux.conf")
backup_dir="$HOME/"

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    backup_file="${file}.bak"
    temp_file="${file}.tmp"
    cp "$file" "$temp_file"
    if [ -f "$backup_file" ]; then
      cmp "$file" "$backup_file"
      if cmp -s "$temp_file" "$backup_file"; then
        rm "$temp_file"
        continue
      fi
    fi

    cp "$temp_file" "$backup_file"
    echo "Respaldo creado: $backup_file"

    rm "$temp_file"
  fi
done
