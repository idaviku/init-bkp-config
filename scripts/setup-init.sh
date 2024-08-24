#!/bin/bash
RED="\033[1;31m"
GREEN="\033[1;32m"
BG_GREEN="\033[1;42m"
YELLOW="\033[1;33m"
NCOLOR="\033[0m"

package_manager=("apt" "pacman" "yum" "dnf" "zypper" "apk")
main_package=("zsh" "tmux" "curl" "git" "gcc" "bash" "gawk" "sed" "python" "python-pip" "make" "cmake" "net-tools" "nmap" "man-db" "docker" "docker-compose")
extra_programs=("vim" "javac" "mysql" "sqlite3" "psql" "redis-cli" "kubectl" "tcpdump" "ansible" "chef" "puppet" "fail2ban" "rst2man")

my_package_manager=""
not_installed=()
count_installed=0

for pck in "${package_manager[@]}";do
  if command -v "$pck" &> /dev/null;then
    my_package_manager="$pck"
    break
  fi
done
if [ -z "$my_package_manager" ];then
  echo -e "Gestor de paquete: ${RED}Undefine${NCOLOR}"
else
  echo -e "Gestor de paquete: $BG_GREEN[$my_package_manager]$NCOLOR\n"
fi

echo "Paquetes base: ${#main_package[@]}"
setup_crontab() {
  echo "Configurando crontab..."
  (crontab -l 2>/dev/null; echo "0 3 * * * /path/to/your/script.sh") | crontab -
}
check_packagev2() {
  echo -e "Verificando paquetes..."
  not_installed=()  # Reiniciar la lista de paquetes no instalados
  count_installed=0  # Reiniciar el contador

  for pck in "${main_package[@]}"; do
    case $my_package_manager in
      apt)
        if apt list --installed $pck &>/dev/null; then
          formato_pck=$(apt list --installed $pck 2>/dev/null | awk -F '[ /]' '/^$pck/ {print $1,$3} ')
          echo -e "$GREEN\u00BB$NCOLOR $pck"
          count_installed=$((count_installed + 1))
        else
          echo -e "$RED\u00BB$NCOLOR $pck"
          not_installed+=("$pck")
        fi
        ;;
      pacman)
        if pacman -Q $pck &>/dev/null; then
          echo -e "$GREEN\u00BB$NCOLOR $pck"
          count_installed=$((count_installed + 1))
        else
          echo -e "$RED\u00BB$NCOLOR $pck"
          not_installed+=("$pck")
        fi
        ;;
      yum)
        if rpm -q "$pck" &> /dev/null; then
          echo -e "$GREEN\u00BB$NCOLOR $pck"
          count_installed=$((count_installed + 1))
        else
          echo -e "$RED\u00BB$NCOLOR $pck"
          not_installed+=("$pck")
        fi
        ;;
      dnf)
        if dnf list installed "$pck" &> /dev/null; then
          echo -e "$GREEN\u00BB$NCOLOR $pck"
          count_installed=$((count_installed + 1))
        else
          echo -e "$RED\u00BB$NCOLOR $pck"
          not_installed+=("$pck")
        fi
        ;;
      zypper)
        if zypper se --installed-only "$pck" &> /dev/null; then
          echo -e "$GREEN\u00BB$NCOLOR $pck"
          count_installed=$((count_installed + 1))
        else
          echo -e "$RED\u00BB$NCOLOR $pck"
          not_installed+=("$pck")
        fi
        ;;
      apk)
        if apk info | grep -qw "$pck"; then
          echo -e "$GREEN\u00BB$NCOLOR $pck"
          count_installed=$((count_installed + 1))
        else
          echo -e "$RED\u00BB$NCOLOR $pck"
          not_installed+=("$pck")
        fi
        ;;
      *)
        echo -e "${RED}Gestor de paquetes desconocido: $my_package_manager${NCOLOR}"
        return 1
        ;;
    esac
  done

  echo "Paquetes instalados: $count_installed"
  echo -e "No instalados: ${RED}${not_installed[@]}${NCOLOR}\n"
}
install_with_package(){
  if [ ${#not_installed[@]} -eq 0 ];then
    echo "Paquetes base instalados"
    return
  fi

  case $my_package_manager in
    apt|yum|dnf|zypper)
      echo "sudo $my_package_manager install -y ${not_installed[@]}"
      ;;
    pacman)
      echo "sudo $my_package_manager -S --noconfirm ${not_installed[@]}"
      ;;
    apk)
      echo "sudo $my_package_manager add --no-cache ${not_installed[@]}"
      ;;
    *)
      echo "No se reconoce gestor de paquete"
      ;;
  esac
}
install_node_repo(){
  # installs nvm (Node Version Manager)
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  # download and install Node.js (you may need to restart the terminal)
  nvm install 20
  # verifies the right Node.js version is in the environment
  node -v # should print `v20.17.0`
  # verifies the right npm version is in the environment
  npm -v # should print `10.8.2`
}
install_vim_repo(){
  git clone https://github.com/vim/vim.git
  cd vim/vim/src
  make distclean
  ./configure \
      --with-features=huge \
      --enable-python3interp \
      --enable-luainterp \
      --enable-rubyinterp \
      --enable-clipboard \
      --enable-gui=gtk3 \
      --enable-cscope \
      --prefix=/usr/local
  make
  sudo make install
}
install_javac_repo(){
  curl -O "https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz"
  sudo tar -xzf "openjdk-17.0.2_linux-x64_bin.tar.gz" -C /usr/locla
  echo "export JAVA_HOME=/usr/local/jdk-17.0.2" >> ~/.zshrc
  echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.zshrc
  source ~/.zshrc
  java -version
  javac -version
}
install_kubectl_repo(){
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  kubectl version --client
  rm kubectl kubectl.sha256
}
install_tcpdump_repo(){
  curl -O "https://www.tcpdump.org/release/tcpdump-4.99.4.tar.xz"
  tar -xzf tcpdump-4.99.4.tar.xz
  cd tcpdump-4.99.4
  ./configure
  make
  sudo make install
  tcpdump --version
}
install_fail2ban_repo(){
  git clone https://github.com/fail2ban/fail2ban.git
  cd fail2ban
  sudo python setup.py install 
  fail2ban-client version
}
install_extra_package(){
  for pck in "${extra_programs[@]}"; do
    if ! command -v $pck &>/dev/null ;then
      echo -ne "Instalar ${YELLOW}$pck [s/n]:${NCOLOR}"
      read -r resp_install
      resp_install=$(echo "$resp_install" | tr '[:upper:]' '[:lower:]')
      if [[ -z "$resp_install" || "$resp_install" == "s" || "$resp_install" == "si" ]];then
        echo -e "continua instalacion\n"
        install_"$pck"_repo
      else
        echo -e "se cancela instalacion de $pck\n"
      fi
    fi
  done
}
#setup_crontab
check_packagev2
install_with_package
echo "Paquetes extras:${#extra_programs[@]}"
install_extra_package
echo "Configuración e instalación inicial completada."
