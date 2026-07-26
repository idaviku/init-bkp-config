#!/usr/bin/env zsh

# ==============================================================================
# SCRIPT: battery_monitor.sh
# DESCRIPCIÓN: Monitoreo de batería con alertas de audio estables y GUI para Cron.
# ==============================================================================

# --- Configuración Estricta de Shell ---
set -o PIPEFAIL

# --- Variables de Entorno y Configuración ---
readonly LOG_FILE="$HOME/.local/state/battery_monitor.log"
readonly AUDIO_FILE="$HOME/.local/share/sounds/sweet_text.mp3"
readonly TARGET_VOLUME="40%" # Volumen fijo ideal para la alerta

# Crear directorio de logs si no existe
mkdir -p "$(dirname "$LOG_FILE")"

# --- Función de Logging Estructurado (JSON-like o ISO Standard) ---
log_message() {
    local level="$1"
    local message="$2"
    echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') [$level] $message" >> "$LOG_FILE"
}

# --- Validación de Dependencias ---
readonly DEPS=(upower zenity paplay pactl grep head date)
for dep in $DEPS; do
    if ! command -v "$dep" &> /dev/null; then
        log_message "ERROR" "Dependencia faltante: $dep. Abortando."
        exit 1
    fi
done

# --- Obtención de Dispositivos de Energía ---
readonly BAT_DEV=$(upower -e | grep 'battery' | head -n 1)
readonly AC_DEV=$(upower -e | grep -E 'line_power|AC|AD' | head -n 1)

if [[ -z "$BAT_DEV" || -z "$AC_DEV" ]]; then
    log_message "ERROR" "No se detectó hardware de energía compatible."
    exit 1
fi

# --- Recolección de Datos ---
battery_info=$(upower -i "$BAT_DEV")
percentage=$(echo "$battery_info" | grep "percentage" | grep -oE '[0-1]?[0-9]{1,2}')
charger_status="off-line"

if upower -i "$AC_DEV" | grep -qE "online:\s+yes"; then
    charger_status="on-line"
fi

#log_message "INFO" "Status -> Bat: ${percentage}% | Charger: ${charger_status}"

# --- Lógica de Control de Audio Seguro ---
play_safe_audio() {
    # Obtener el volumen actual del sink por defecto (para restaurarlo luego)
    local current_vol
    current_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=% )' | head -n 1)
    
    # Validar que obtuvimos el volumen, si no, usar 50% por defecto
    [[ -z "$current_vol" ]] && current_vol=50

    # Establecer volumen seguro, reproducir y restaurar
    pactl set-sink-volume @DEFAULT_SINK@ "$TARGET_VOLUME"
    paplay "$AUDIO_FILE"
    pactl set-sink-volume @DEFAULT_SINK@ "${current_vol}%"
}

# --- Lógica de Alertas e Inyección de Entorno Gráfico ---
send_alert() {
    local msg="$1"
    log_message "WARNING" "Disparando alerta: $msg"
    
    # 1. Definir rutas base del usuario running cron
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
    export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

    # 2. DETECCIÓN DINÁMICA: Buscar si el usuario tiene una sesión Wayland o X11 activa
    if [[ -z "$WAYLAND_DISPLAY" ]]; then
        # Intentar rescatar WAYLAND_DISPLAY desde el entorno del usuario
        export WAYLAND_DISPLAY=$(pgrep -u $(id -u) -a sway | grep -oP 'WAYLAND_DISPLAY=\K\S+' | head -n 1)
        # Si no es Sway, buscar cualquier socket activo en runtime
        [[ -z "$WAYLAND_DISPLAY" ]] && export WAYLAND_DISPLAY=$(ls ${XDG_RUNTIME_DIR}/wayland-* 2>/dev/null | head -n 1 | xargs basename)
    fi

    if [[ -z "$DISPLAY" ]]; then
        # Si no hay Wayland, heredar X11 clásico
        export DISPLAY=:0
        export XAUTHORITY="$HOME/.Xauthority"
    fi

    # Reproducir audio de fondo para no bloquear la GUI
    play_safe_audio &
    
    # Ejecutar Zenity de forma segura
    zenity --warning --title="Gestión de Energía" --text="$msg" --timeout=15
}


# --- Evaluación de Reglas de Negocio ---
if [[ "$charger_status" == "off-line" && "$percentage" -le 25 ]]; then
    send_alert "Batería Crítica: ${percentage}%. ¡Conecta el cargador inmediatamente!"
elif [[ "$charger_status" == "on-line" && "$percentage" -ge 85 ]]; then
    send_alert "Carga Optimizada: ${percentage}%. Desconecta para proteger la vida útil."
fi
