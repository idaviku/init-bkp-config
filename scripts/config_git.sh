#!/bin/bash

# Función para mostrar la configuración actual de Git
show_git_config() {
    echo "Configuración actual de Git:"
    git config --list
}
echo "Verificando la configuración actual de Git..."
show_git_config

# Preguntar al usuario si desea modificar la configuración actual
read -p "¿Deseas modificar la configuración de Git? (yes/no): " modify_config

if [[ "$modify_config" == "yes" ]]; then
    # Solicitar nuevas configuraciones
    read -p "Introduce tu nombre: " git_name
    read -p "Introduce tu correo:" git_email
    read -p "Introduce el editor de texto (por defecto 'nano'): " git_editor
    git_editor=${git_editor:-nano}  # Usar 'nano' por defecto si no se proporciona nada

    echo "Configurando Git..."
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global core.editor "$git_editor"
    git config --global color.ui auto
    git config --global push.default simple
    git config --global init.defaultbranch=main

    echo "Nueva configuración de Git:"
    show_git_config
else
    echo "La configuración de Git no ha sido modificada."
fi

# Generar clave SSH
echo "Generando clave SSH..."
ssh_key_path="$HOME/.ssh/id_rsa"
if [ -f "$ssh_key_path" ]; then
    echo "La clave SSH ya existe en $ssh_key_path."
else
    read -p "Introduce un nombre para la clave SSH (por defecto 'id_rsa'): " ssh_key_name
    ssh_key_name=${ssh_key_name:-id_rsa}  # Usar 'id_rsa' por defecto si no se proporciona nada
    ssh-keygen -t rsa -b 4096 -C "$git_email" -f "$HOME/.ssh/$ssh_key_name"
    echo "Clave SSH generada en $HOME/.ssh/$ssh_key_name"
fi

# Mostrar la clave pública
echo "La clave pública SSH es:"
cat "$HOME/.ssh/${ssh_key_name}.pub"
echo "Si estás usando GitHub, puedes añadir la clave aquí: https://github.com/settings/keys"
echo "Configuración inicial de Git completada."
exit 0
