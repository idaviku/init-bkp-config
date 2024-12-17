#!/bin/bash
# -----------------------------------------------------------------------------
# Nombre del script: sync2repo.sh 
# Descripción: Script para sincronizar los archivos de configuracion del
# repositorio a el REPOSITORIO
# Autor: @idaviku
# Fecha de creación: 2024-10-26
# Última modificación: 15/12/2024 domingo
# -----------------------------------------------------------------------------

bkp_path=$(dirname $(dirname "$(realpath "$0")"))  
files=(".toprc" ".vimrc" ".zshrc" ".tmux.conf" "_vimrc")

if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  files=("_vimrc")
fi

if command -v rsync &> /dev/null; then
  for file in "${files[@]}"; do
    src="$bkp_path/$file"
    dest="$HOME/$file"
    rsync -azP "$dest" "$src"
  done
else
  for file in "${files[@]}"; do
    src="$bkp_path/$file"
    dest="$HOME/$file"
    cp "$dest" "$src"
  done
fi
