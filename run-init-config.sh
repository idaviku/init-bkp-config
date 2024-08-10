#!/bin/bash

# Configura el acceso al servidor X
export DISPLAY=:0
export XAUTHORITY=/home/tu_usuario/.Xauthority

# Permitir acceso solo para el script en ejecución
xhost +local:cron

# Ejecuta el script deseado
/home/davik/rootx56/config/init-bkp-config/safe-baterry.sh
/usr/bin/zenity --info --text="Esto es una prueba desde cron."
# Revertir los permisos para mayor seguridad
xhost -local:cron
