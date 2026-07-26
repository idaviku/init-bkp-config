# =============================================================================
# ARCHIVO DE CONFIGURACIÓN ZSH (.zshrc) - ENTORNO MULTIUSO SEGURO
# Auditoría: Optimizado, Carga Asíncrona/Lazy y Manejo Estricto de Historial
# =============================================================================

# --- 1. VARIABLES DE ENTORNO DE USUARIO & SYSTEM ---
export ZSH="$HOME/.oh-my-zsh"
export VIMRC="$HOME/.vimrc"
export VISUAL="vim"
export EDITOR="vim"
# D2 Diagram Engine
export PATH="$HOME/.local/bin:$PATH"
export MANPATH="$HOME/.local/share/man:$MANPATH"
export NO_AT_SPI_CLIENT=1

# Configuración de renderizado gráfico de Frameworks (Wayland/XFCE/Artix Linux)
export QT_QPA_PLATFORM="wayland"
#export QT_XCB_GL_INTEGRATION=none
export QT_FONT_DPI=120
# Fuerza el backend de Wayland para aplicaciones GTK
export MOZ_ENABLE_WAYLAND=1
export GDK_BACKEND="wayland"
# Corrección para aplicaciones Java (como IntelliJ o herramientas de desarrollo) bajo Wayland
export _JAVA_AWT_WM_NONREPARENTING=1

# Inicialización segura de X11 (Silencia errores si se ejecuta fuera de XFCE/SSH)
#command -v xset &>/dev/null && xset b off 2>/dev/null

# --- 2. GOBERNANZA Y POLÍTICA DEL HISTORIAL (CIS Compliance) ---
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000        # Capacidad de comandos en memoria RAM
export SAVEHIST=10000        # Línea de comandos máximas escritas a disco
export HISTDUP=erase

setopt appendhistory
setopt sharehistory          # Comparte historial entre terminales activas en tiempo real
setopt hist_ignore_space     # SI EMPIEZAS UN COMANDO CON ESPACIO, NO SE GUARDA (Ideal para contraseñas/Tokens)
setopt hist_ignore_all_dups  # Borra duplicados anteriores si el comando nuevo coincide
setopt hist_save_no_dups     # Evita escribir duplicados al archivo físico
setopt hist_find_no_dups     # Ignora duplicados al buscar con flechas

# --- 3. CONFIGURACIÓN DE PLUGINS (OH-MY-ZSH) ---
# Tema visual optimizado para terminales estándar
ZSH_THEME="xiong-chiamiov-plus"

# Los plugins declarados aquí son cargados de forma automática y óptima por OMZ.
# ¡Eliminamos la carga duplicada manual ("source") del fondo del archivo!
plugins=(
  git
  z
  fzf
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-history-substring-search
)

# Carga inicial del framework Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Inyección segura de complementos y parches del sistema
[ -f "$HOME/.local/share/.silntK.bak" ] && source "$HOME/.local/share/.silntK.bak"

# Configuración del motor complementario FZF-Tab (Asegura persistencia posterior a OMZ)
if [ -f "$HOME/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.zsh" ]; then
    source "$HOME/.oh-my-zsh/custom/plugins/fzf-tab/fzf-tab.zsh"
fi

# Mapeo de teclas seguro e idempotente para búsqueda del historial
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- 4. OPTIMIZACIÓN DE RENDIMIENTO: LAZY LOADING (Carga Perezosa) ---

# Carga Perezosa de NVM (Evita ralentizar la terminal al abrirla)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    nvm() {
        unset -f nvm node npm
        source "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
        nvm "$@"
    }
    # Proxies para interceptar comandos globales antes de inicializar NVM completo
    node() { unset -f nvm node npm; source "$NVM_DIR/nvm.sh"; node "$@"; }
    npm() { unset -f nvm node npm; source "$NVM_DIR/nvm.sh"; npm "$@"; }
fi

# Carga Perezosa de Anaconda / Conda Python
if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
    conda() {
        unset -f conda
        export PATH="/opt/anaconda3/bin:$PATH"
        source "/opt/anaconda3/etc/profile.d/conda.sh"
        conda "$@"
    }
fi

# --- 5. CONFIGURACIÓN DE ESTILOS Y AUTOCOMPLETADO INTERACTIVO ---
autoload -Uz compinit && compinit -d "$HOME/.zcompdump"
zstyle ':completion:*' menu no

# --- 6. ALIASES DE EFICIENCIA Y REDUNDANCIA ---
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lAh'
alias grep='grep --color=auto'
alias ..='cd ..'
alias vrc='vim ~/.vimrc'
alias zrc='vim ~/.zshrc'

# --- 7. FUNCIONES EXTENDIDAS DE INVESTIGACIÓN Y REFACTORIZACIÓN ---

# Auditoría rápida de cabeceras de red
checklink() { curl -s -I -L "$1" | grep -iE "link:|location:|server:|http/"; }

# Decodificador hexadecimal (Análisis de binarios/Redes)
wifixhexa() { echo "$1" | xxd -r -p; }

# Reemplazo seguro de espacios en archivos para scripting (Evita romper bucles)
deletespaces() {
    local target_dir="${1:-.}"
    find "$target_dir" -maxdepth 1 -name "* *" -print0 | while IFS= read -r -d '' file; do
        local dest="${file// /-}"
        mv -v "$file" "$dest"
    done
}

# Uso de disco inteligente optimizado para find
diskUsage() {
    local size_filter="${1:-+100M}"
    find ./ -type f -size "$size_filter" -exec du -ah {} + | sort -rh
}

# Extractor Universal de Archivos
extract() {
    if [ -f "$1" ]; then
        filename=$(basename -- "$1")
        dirname="${filename%.*}"
        mkdir -p "$dirname"

        case "$1" in
            *.tar.bz2)   tar xjf "$1" -C "$dirname"     ;;
            *.tar.gz)    tar xzf "$1" -C "$dirname"     ;;
            *.bz2)       bunzip2 -c "$1" > "$dirname/${filename%.*}" ;;
            *.rar)       unrar x "$1" "$dirname/"       ;;
            *.gz)        gunzip -c "$1" > "$dirname/${filename%.*}" ;;
            *.tar)       tar xf "$1" -C "$dirname"      ;;
            *.tbz2)      tar xjf "$1" -C "$dirname"     ;;
            *.tgz)       tar xzf "$1" -C "$dirname"     ;;
            *.zip)       unzip -d "$dirname" "$1"       ;;
            *.Z)         uncompress -c "$1" > "$dirname/${filename%.*}" ;;
            *.7z)        7z x "$1" -o"$dirname"         ;;
            *)           echo "'$1' no puede ser extraído mediante extract()" ;;
        esac
    else
        echo "'$1' no es un archivo válido"
    fi
}

#Clonador Limpio de Investigación Temporal
tmpclone() {
    if [ -z "$1" ]; then
        echo "Uso: tmpclone <url_repositorio_git>"
        return 1
    fi
    local repo_dir="/tmp/repo_$(date +%s)"
    mkdir -p "$repo_dir" && cd "$repo_dir"
    git clone --depth 1 "$1"
    local projected_folder=$(ls -d */ 2>/dev/null | head -n 1)
    [ -n "$projected_folder" ] && cd "$projected_folder"
}

#Escáner de Puertos Ultraligero Nativo
ezportcheck() {
    local host="${1:-127.0.0.1}"
    local port="${2:-80}"
    (zmodload zsh/net/tcp && ztcp -d 3 "$host" "$port") &>/dev/null
    if [ $? -eq 0 ]; then
        echo "Port $port en $host esta [ABIERTO]"
        exec 3>&- # Cerrar socket de forma segura
    else
        echo "Port $port en $host esta [CERRADO / BLOQUEADO]"
    fi
}

# --- CONFIGURACIÓN AVANZADA Y COMPILACIÓN DE AUTOCOMPLETADO ---
# Definir una ruta estática y limpia para la caché
export ZSH_COMPDUMP="$HOME/.zcompdump"


# Compilación asíncrona automática a Bytecode (.zwc) para un arranque instantáneo
if [ -f "$ZSH_COMPDUMP" ]; then
    # Si el archivo original es más nuevo que el compilado .zwc, re-compila en silencio
    if [ ! -f "${ZSH_COMPDUMP}.zwc" ] || [ "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc" ]; then
        zcompile "$ZSH_COMPDUMP"
    fi
fi


# lanzador de yazi 
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}


# Gestor interactivo de USBs con udisksctl
mountUsb() {
  # 1. Verificar si fzf está instalado
  if ! command -v fzf &> /dev/null; then
    echo "Error: 'fzf' no está instalado. Instálalo con: sudo pacman -S fzf"
    return 1
  fi

  # 2. Menú principal: ¿Qué quiere hacer el usuario?
  local accion
  accion=$(printf "Montar_Particion\nDesmontar_Particion\nApagar_Dispositivo(Power-off)\nVer_Estado" | fzf --height=40% --layout=reverse --header="[ Gestor USB udisksctl ] Selecciona una acción:")

  case "$accion" in
    "Ver_Estado")
      echo "--- Estado actual de los dispositivos ---"
      udisksctl status
      ;;

    "Montar_Particion")
      # Lista solo las particiones (ej: sda1, sdb1) que NO estén montadas todavía
      local particion
      particion=$(lsblk -plo NAME,SIZE,TYPE,MOUNTPOINT | grep "part" | grep -v "/" | fzf --height=40% --layout=reverse --header="Selecciona la partición a MONTAR:")

      if [ -n "$particion" ]; then
        local dev_part=$(echo "$particion" | awk '{print $1}')
        udisksctl mount -b "$dev_part"
      fi
      ;;

    "Desmontar_Particion")
      # Lista solo las particiones que SÍ están montadas actualmente bajo /run/media o /mnt
      local particion_montada
      particion_montada=$(lsblk -plo NAME,SIZE,TYPE,MOUNTPOINT | grep "part" | grep -E "/run/media|/mnt" | fzf --height=40% --layout=reverse --header="Selecciona la partición a DESMONTAR:")

      if [ -n "$particion_montada" ]; then
        local dev_part_m=$(echo "$particion_montada" | awk '{print $1}')
        udisksctl unmount -b "$dev_part_m"
      fi
      ;;

    "Apagar_Dispositivo(Power-off)")
      # Lista los discos completos (ej: sda, sdb), excluyendo el disco principal nvme
      local disco
      disco=$(lsblk -plo NAME,SIZE,TYPE | grep "disk" | grep -v "nvme" | fzf --height=40% --layout=reverse --header="Selecciona el disco físico a APAGAR de forma segura:")

      if [ -n "$disco" ]; then
        local dev_disco=$(echo "$disco" | awk '{print $1}')
        udisksctl power-off -b "$dev_disco"
      fi
      ;;

    *)
      echo "Operación cancelada."
      ;;
  esac
}

yt-play() {
  echo -n "🔍 ¿Qué quieres escuchar? (Canción, artista o álbum): "
  read -r busqueda

  if [ -z "$busqueda" ]; then
    echo "❌ Búsqueda cancelada."
    return
  fi

  echo -e "\n⚙️  Modo de reproducción:"
  echo " [1] Solo una canción (Audio)"
  echo " [2] Canción + Reproducción continua (Radio / Autoplay)"
  echo " [3] Reproducir con VIDEO"
  echo -n "👉 Elige una opción [1-3] (Default: 1): "
  read -r modo

  echo -e "\n🔎 Buscando en YouTube..."

  # Buscamos con yt-dlp y fzf
  local elegido=$(yt-dlp "ytsearch20:$busqueda" --flat-playlist --dump-json 2>/dev/null | \
    jq -r 'select(.id != null) | "\(.title) | https://www.youtube.com/watch?v=\(.id)"' | \
    fzf --prompt="🎵 Selecciona una canción: " --height=40% --layout=reverse)

  if [ -z "$elegido" ]; then
    echo "❌ No se seleccionó nada."
    return
  fi

  # Extraemos la URL, ID y título limpiamente
  local url="${elegido##* | }"
  local video_id="${url##*=}"
  local titulo="${elegido% | *}"

  # Formato de consola para ver Nombre / Canal en tiempo real
  local term_msg='▶️  ${media-title} | 👤 ${metadata/by-key/uploader}\n⏱️  [${time-pos} / ${duration}]'

  case "$modo" in
    2)
      # MODO CONTINUO / RADIO (Audio)
      echo -e "\n📻 Iniciando Radio Continuo basado en: $titulo\n"
      mpv --no-video \
          --term-status-msg="$term_msg" \
          --ytdl-raw-options="yes-playlist=,extractor-args=youtube:player_client=android" \
          "https://www.youtube.com/watch?v=${video_id}&list=RD${video_id}"
      ;;

    3)
      # MODO VIDEO (Límite suave de 1080p sin romper búsquedas)
      # --ytdl-raw-options="extractor-args=youtube:player_client=web" \
      #--ytdl-format="bestvideo[height<=?720]+bestaudio/best" \
      # --ytdl-format="bestvideo[height<=1080]+bestaudio/best" \
      echo -e "\n🎬 Reproduciendo Video: $titulo\n"
      mpv --term-status-msg="$term_msg" \
          --ytdl-format="bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=1080]+bestaudio/best" \
          "$url"
      ;;

    *)
      # MODO SOLO UNA CANCIÓN (Audio)
      echo -e "\n🎵 Reproduciendo: $titulo\n"
      mpv --no-video \
          --term-status-msg="$term_msg" \
          --ytdl-raw-options="extractor-args=youtube:player_client=android" \
          "$url"
      ;;
  esac
}

# Alias
alias yt-play=" yt-play"

