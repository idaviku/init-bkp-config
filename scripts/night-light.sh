#!/bin/bash

# -----------------------------------------------------------------------------
# Nombre del script: night-light.sh
# Descripción: Script para ajustar la temperatura del color de la pantalla 
# segun el horario (luz nocturna) el parametro gamma (r:g:b) [0=menos 1=mas]
# Autor: @idaviku
# Fecha de creación:20/10/2024  
# Última modificación: 
# Versión: 1.0
# Licencia: MIT
# -----------------------------------------------------------------------------

export DISPLAY=:0
OUTPUT=$(xrandr|grep -w "connected"|awk '{print $1}') 

HORA_ACTUAL=$(date +%H)

if [ $HORA_ACTUAL -ge 18 ] || [ $HORA_ACTUAL -lt 6 ]; then
  for OUTPUTX in ${OUTPUT}; do
    xrandr --output $OUTPUTX --gamma 1:0.5:0.2
  done
  echo "Luz nocturna activada."
else
  for outputX in ${OUTPUT}; do
    xrandr --output $OUTPUT --gamma 1:1:1
  done
  echo "Colores restaurados a la normalidad."
fi
