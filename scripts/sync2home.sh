#!/bin/bash
# -----------------------------------------------------------------------------
# Nombre del script: sync2home.sh 
# Descripción: Script para sincronizar los archivos de configuracion del
# repositorio a el HOME
# Autor: @idaviku
# Fecha de creación: 2024-10-26
# Última modificación:29/07/2026 miércoles
# -----------------------------------------------------------------------------
#
bkp_path=$(dirname $(dirname "$(realpath "$0")"))  

# 1. Archivos base en el HOME
home_files=(".toprc" ".vimrc" ".zshrc" ".tmux.conf" "_vimrc")

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  home_files=("_vimrc")
fi

# 2. Directorios o archivos dentro de ~/.config
config_files=("i3status" "foot" "kanshi" "gammastep" "sway" "yazi")

# Restaurar archivos del HOME
if command -v rsync &> /dev/null; then
  for file in "${home_files[@]}"; do
    src="$bkp_path/$file"
    dest="$HOME/$file"
    if [ -f "$src" ]; then
      rsync -azP "$src" "$dest"
    fi
  done

  # Restaurar elementos de .config
  for item in "${config_files[@]}"; do
    src="$bkp_path/.config/$item"
    dest="$HOME/.config/$item"
    if [ -e "$src" ]; then
      mkdir -p "$dest"
      rsync -azP --delete "$src/" "$dest/"
    fi
  done
else
  # Fallback a cp si no hay rsync
  for file in "${home_files[@]}"; do
    [ -f "$bkp_path/$file" ] && cp "$bkp_path/$file" "$HOME/$file" && echo "[HOME] Copiado: $file"
  done
  for item in "${config_files[@]}"; do
    if [ -e "$bkp_path/.config/$item" ]; then
      mkdir -p "$HOME/.config/$item"
      cp -r "$bkp_path/.config/$item/." "$HOME/.config/$item/"
    fi
  done
fi

bkp_path=$(dirname $(dirname "$(realpath "$0")"))  
files=(".toprc" ".vimrc" ".zshrc" ".tmux.conf" "_vimrc")

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  files=("_vimrc")
fi

if command -v rsync &> /dev/null; then
  for file in "${files[@]}"; do
    src="$bkp_path/$file"
    dest="$HOME/$file"
    rsync -azP "$src" "$dest"
  done
else
  for file in "${files[@]}"; do
    src="$bkp_path/$file"
    dest="$HOME/$file"
    cp "$src" "$dest"
  done
fi
