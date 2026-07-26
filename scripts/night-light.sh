#!/usr/bin/env bash

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

# Manejo estricto de errores en Bash
set -o pipefail

# --- Configuración de Variables ---
readonly GAMMA_NIGHT="1.0:0.8:0.5"
readonly GAMMA_DAY="1.0:1.0:1.0"

# Variables de entorno críticas para X11 en Cron
export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"

# --- Validación de Dependencias ---
if ! command -v xrandr &> /dev/null; then
    exit 1
fi

# --- Obtención de Hardware (Compatible con Bash) ---
# Usamos un mapa/bucle compatible con Bash para llenar el array de monitores
declare -a OUTPUTS
while IFS= read -r line; do
    if [[ -n "$line" ]]; then
        OUTPUTS+=("$line")
    fi
done < <(xrandr --query | grep " connected" | cut -d' ' -f1)

# Validación de pantallas conectadas
if [[ ${#OUTPUTS[@]} -eq 0 ]]; then
    exit 1
fi

# --- Lógica de Tiempo ---
current_hour=$(date +%H)
target_gamma=$GAMMA_DAY

# Modo noche de 18:00 a 05:59
if [[ 10#$current_hour -ge 18 || 10#$current_hour -lt 6 ]]; then
    target_gamma=$GAMMA_NIGHT
fi

# --- Aplicación Inteligente (Cortocircuito) ---
for monitor in "${OUTPUTS[@]}"; do
    # Capturar la gamma actual que tiene asignada el monitor en Xorg
    current_gamma=$(xrandr --verbose --output "$monitor" | grep -i "Gamma:" | awk '{print $2}')

    # Homologamos si viene vacío (modo diurno por defecto)
    [[ -z "$current_gamma" ]] && current_gamma="1.0:1.0:1.0"

    # VALIDACIÓN: ¿La gamma actual es diferente a la que queremos aplicar?
    if [[ "$current_gamma" != "$target_gamma" ]]; then
        # Solo interactúa con el hardware si hay un cambio real de estado
        xrandr --output "$monitor" --gamma "$target_gamma" 2>/dev/null
    fi
done
