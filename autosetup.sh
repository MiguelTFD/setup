#!/bin/bash

# Repositorio de dotfiles
repo_url="https://github.com/MiguelTFD/dotfiles.git"

# Obtener el directorio home del usuario actual
if [ -n "$SUDO_USER" ]; then
    home_dir=$(eval echo ~${SUDO_USER})
else
    home_dir="$HOME"
fi

# Función para instalar un paquete
install_package() {
    package=$1
    if sudo apt-get install -y "$package" > /dev/null 2>&1; then
        echo "$package instalado con éxito."
    else
        echo "No se pudo instalar $package."
    fi
}

# Instalar git primero
echo "Instalando git..."
install_package git

# Clonar repositorio de dotfiles en el directorio home del usuario actual
echo "Clonando repositorio de dotfiles..."
if git clone "$repo_url" "$home_dir/dotfiles" > /dev/null 2>&1; then
    echo "Repositorio clonado con éxito en $home_dir/dotfiles."
else
    echo "No se pudo clonar el repositorio."
    exit 1
fi

# Eliminar archivos y directorios en el directorio home que coincidan con los de dotfiles
echo "Eliminando archivos y directorios en $home_dir que coinciden con los de dotfiles..."
cd "$home_dir/dotfiles"
for item in .* *; do
    if [ -e "$home_dir/$item" ]; then
        rm -rf "$home_dir/$item"
        echo "Eliminado $home_dir/$item"
    fi
done

# Mover todo el contenido de dotfiles al directorio home del usuario
echo "Moviendo el contenido de dotfiles al directorio home..."
shopt -s dotglob
mv "$home_dir/dotfiles/"* "$home_dir/"
shopt -u dotglob
rm -rf "$home_dir/dotfiles"
echo "Contenido movido y carpeta dotfiles eliminada."

# Lista de paquetes a instalar
packages=(
    pulseaudio
    ntfs-3g
    curl
    unzip
    build-essential
    vim
    xorg
    i3-wm
    feh
    psmisc
    firefox-esr
    kitty
    python3-pil
    polybar
    rofi
    ranger
    neofetch
    openjdk-17-jdk
    maven
    nodejs
    npm
    php
    lightdm
    light-locker
    dunst
    scrot
    calcurse
    timeshift
    picom
)

# Iterar sobre cada paquete e intentar instalarlo
echo "Instalando paquetes..."
for pkg in "${packages[@]}"; do
    install_package "$pkg"
done

echo "Proceso de instalación de paquetes completado."

sudo cp -r "$home_dir/.themes/Orchis-Dark-Nord" /usr/share/themes/
sudo cp -r "$home_dir/.themes/Orchis-Light-Nord" /usr/share/themes/

sudo cp -r "$home_dir/.local/share/wallpapers/NordTheme" /usr/share/wallpapers/
sudo cp -f "$home_dir/.config/miscellaneous/lightdm/lightdm.conf" /etc/lightdm/


curl -sS https://starship.rs/install.sh | sh
starship preset gruvbox-rainbow -o ~/.config/starship.toml #eliminar esto

echo "Script completado con éxito."
