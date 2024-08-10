#!/bin/bash

export DISPLAY=:0
export XAUTHORITY=$HOME/.Xauthority
export PULSE_SERVER=unix:/run/user/$(id -u)/pulse/native
battery_device=$(upower -e|grep 'battery'|head -n 1)
get_charger_status() {
 acpi -a|grep -o 'on-line\|off-line'
 #upower -i /org/freedesktop/UPower/devices/line_power_AC | grep "online" | awk '{print $2}'
}
get_battery_percentage() {
    upower -i "$battery_device" | grep "percentage" | awk '{print $2}' | sed 's/%//'
}
charger_status=$(get_charger_status)
battery_percentage=$(get_battery_percentage)
if [[ "$charger_status" == "off-line" && "$battery_percentage" -lt 25 ]]; then
    paplay $HOME/Descargas/sweet_text.mp3
    zenity --info --text="Advertencia La bateria esta por debajo del $battery_percentage\% y el cargador esta desconectado."
elif [[ "$charger_status" == "on-line" && "$battery_percentage" -gt 85 ]]; then
    paplay $HOME/Descargas/sweet_text.mp3
    zenity --info --text="La bateria esta por encima del $battery_percentage\% y el cargador esta conectado."
fi

