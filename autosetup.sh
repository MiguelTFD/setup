#!/bin/bash

repo_url="https://github.com/MiguelTFD/dotfiles.git"

get_current_user_home_dir() {
    if [ -n "$SUDO_USER" ]; then
        home_dir=$(eval echo ~${SUDO_USER})
    else
        home_dir="$HOME"
    fi
}
get_current_user_home_dir

install_package() {
    package=$1
    if sudo apt-get install -y "$package" > /dev/null 2>&1; then
        echo "$package instalado con éxito."
    else
        echo "No se pudo instalar $package."
    fi
}
install_package git

clone_repo() {
    echo "Clonando repositorio de dotfiles..."
    if git clone "$repo_url" "$home_dir/dotfiles" > /dev/null 2>&1; then
        echo "Repositorio clonado con éxito en $home_dir/dotfiles."
    else
        echo "No se pudo clonar el repositorio."
        exit 1
    fi
}
clone_repo

remove_default_dotfiles() {
    echo "Eliminando archivos y directorios en $home_dir que coinciden con los de dotfiles..."
    
    cd "$home_dir/dotfiles"
    for item in .* *; do
        if [ -e "$home_dir/$item" ]; then
            rm -rf "$home_dir/$item"
            echo "Eliminado $home_dir/$item"
        fi
    done
}
remove_default_dotfiles

move_repo_dotfiles() {
    echo "Moviendo el contenido de dotfiles al directorio home..."
    
    shopt -s dotglob
    mv "$home_dir/dotfiles/"* "$home_dir/"
    
    shopt -u dotglob
    rm -rf "$home_dir/dotfiles"
    
    echo "Contenido movido y carpeta dotfiles eliminada."
}
move_repo_dotfiles

package_list=(
    # ─── CORE & UTILS ──────────────────────────────────────────────────
    build-essential
    timeshift
    curl
    wget
    git
    rtkit
    unzip
    zip
    jq
    bc

    # ─── NETWORK (TUI First) ───────────────────────────────────────────
    network-manager
    
    # ─── AUDIO (Modern Stack) ──────────────────────────────────────────
    wireplumber
    pipewire
    pipewire-pulse
    pipewire-alsa
    pipewire-jack
    libspa-0.2-bluetooth
    pulsemixer
    
    # ─── WINDOW MANAGER & X11 ──────────────────────────────────────────
    xorg
    i3-wm
    picom
    rofi
    dunst
    libnotify-bin
    xclip
    slop
    lightdm
    light-locker
    polybar
    xdg-desktop-portal-gtk

    # ─── TERMINAL & MODERN UNIX TOOLS ──────────────────────────────────
    alacritty
    tmux
    ripgrep
    fzf
    bat
    lsd
    btop
    psmisc
    nnn

    # ─── DEVELOPMENT TOOLS ─────────────────────────────────────────────
    vim

    # ─── BROWSERS ──────────────────────────────────────────────────────
    firefox-esr
    chromium

    # ─── MULTIMEDIA & SCREEN ───────────────────────────────────────────
    ffmpeg
    mpv
    maim
    zathura
    feh

    # ─── AESTHETICS ────────────────────────────────────────────────────
    cava
    tty-clock
)

echo "Instalando paquetes..."
for pkg in "${package_list[@]}"; do
    install_package "$pkg"
done
echo "Proceso de instalacion de paquetes completado."

sudo cp -r "$home_dir/.themes/Gruvbox-Dark-Medium" /usr/share/themes/
sudo cp -r "$home_dir/.themes/Gruvbox-Dark-Medium-xhdpi/" /usr/share/themes/
sudo cp -r "$home_dir/.themes/Gruvbox-Dark-Medium-hdpi/" /usr/share/themes/

sudo cp -r "$home_dir/.local/share/wallpapers/Gruvbox" /usr/share/wallpapers/
sudo cp -f "$home_dir/.config/miscellaneous/lightdm/lightdm.conf" /etc/lightdm/

sudo cp -r "$home_dir/.themes/Gruvbox-Light" /usr/share/themes/
sudo cp -r "$home_dir/.themes/Gruvbox-Light-xhdpi/" /usr/share/themes/
sudo cp -r "$home_dir/.themes/Gruvbox-Light-hdpi/" /usr/share/themes/

sudo cp -r "$home_dir/.icons/"* /usr/share/icons/

echo "Script completado con éxito."
