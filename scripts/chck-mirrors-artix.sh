#!/bin/bash
# -----------------------------------------------------------------------------
# Nombre del script: chck-mirrors-artix.sh 
# Descripción: script para revisar que servidor de paquete es recomendable
# para mi ubicacion.
# Autor: daviku
# Fecha de creación: 2025-04-15
# Última modificación: 2025-04-15
# Versión: 1.0
# Licencia: MIT
# -----------------------------------------------------------------------------


MIRRORLIST="/etc/pacman.d/mirrorlist"
#MIRRORLIST="$HOME/mirrorslist"
RESULTS="/tmp/mirror_resultsx.txt"

echo " Probando mirrors en Artix Linux..."
echo "Resultados guardados en: $RESULTS"
echo -e "Mirror | Latencia (ms) | Velocidad (KB/s)\n" > "$RESULTS"

MIRRORS=$(grep '^Server =' "$MIRRORLIST" | sed 's/^Server = //')

for MIRROR in $MIRRORS; do
  BASE_URL=$(echo "$MIRROR" | sed 's/$repo\/os\/$arch//')

  PING_TIME=$(ping -c 3 -q "$(echo "$BASE_URL" | awk -F/ '{print $3}')" | awk -F'/' '/rtt/ {print $5}')

  DOWNLOAD_SPEED=$(curl -o /dev/null -w "%{speed_download}\n" -s "${BASE_URL}core/os/x86_64/core.db.tar.gz" | awk '{printf "%.2f KB/s\n", $1/1024}')

  echo -e "$BASE_URL | $PING_TIME ms | $DOWNLOAD_SPEED" >> "$RESULTS"
done

echo -e "\n Mirrors ordenados por mejor rendimiento:\n"
sort -t '|' -k2 -n "$RESULTS"
echo -e "\n Los mejores mirrors están listados arriba. Puedes actualizar tu mirrorlist manualmente."
