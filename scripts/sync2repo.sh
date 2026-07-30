#!/bin/bash
# -----------------------------------------------------------------------------
# Nombre del script: sync2repo.sh 
# Descripción: Script para sincronizar los archivos de configuracion del
# repositorio a el REPOSITORIO
# Autor: @idaviku
# Fecha de creación: 2024-10-26
# Última modificación:29/07/2026 miércoles 
# # -----------------------------------------------------------------------------

bkp_path=$(dirname $(dirname "$(realpath "$0")"))  

# 1. Archivos base en el HOME
home_files=(".toprc" ".vimrc" ".zshrc" ".tmux.conf" "_vimrc")

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  home_files=("_vimrc")
fi


# 2. Directorios o archivos dentro de ~/.config que deseas sincronizar
config_files=("i3status" "foot" "kanshi" "gammastep" "sway" "yazi")

# Sincronizar archivos del HOME
if command -v rsync &> /dev/null; then
  for file in "${home_files[@]}"; do
    src="$bkp_path/$file"
    dest="$HOME/$file"
    if [ -f "$dest" ]; then
      rsync -azP "$dest" "$src"
    fi
  done

  # Sincronizar elementos de .config
  for item in "${config_files[@]}"; do
    src="$bkp_path/.config/$item"
    dest="$HOME/.config/$item"
    if [ -e "$dest" ]; then
      mkdir -p "$src"
      rsync -azP --delete "$dest/" "$src/"
    fi
  done
else
  # Fallback a cp si no hay rsync
  for file in "${home_files[@]}"; do
    [ -f "$HOME/$file" ] && cp "$HOME/$file" "$bkp_path/$file" && echo "[HOME] Copiado: $file"
  done
  for item in "${config_files[@]}"; do
    if [ -e "$HOME/.config/$item" ]; then
      mkdir -p "$bkp_path/.config/$item"
      cp -r "$HOME/.config/$item/." "$bkp_path/.config/$item/"
    fi
  done
fi

