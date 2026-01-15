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
        echo "pakage $package has been installed."
    else
        echo "cannot install $package pakage."
    fi
}
install_package git

clone_repo() {
    echo "Cloning dotfiles repo..."
    if git clone "$repo_url" "$home_dir/dotfiles" > /dev/null 2>&1; then
        echo "dotfiles repo has been cloned on $home_dir/dotfiles."
    else
        echo "Fail to cloning the repository."
        exit 1
    fi
}
clone_repo

remove_default_dotfiles() {
    echo "Removing default files on $home_dir ..."
    
    cd "$home_dir/dotfiles"
    for item in .* *; do
        if [ -e "$home_dir/$item" ]; then
            rm -rf "$home_dir/$item"
            echo "Removed $home_dir/$item"
        fi
    done
}
remove_default_dotfiles

move_repo_dotfiles() {
    echo "Moving dotfiles to home directory..."
    
    shopt -s dotglob
    mv "$home_dir/dotfiles/"* "$home_dir/"
    
    shopt -u dotglob
    rm -rf "$home_dir/dotfiles"
    
    echo "Files moved succesfully."
}
move_repo_dotfiles

package_list=(
    # ─── CORE & UTILS ──────────────────────────────────────────────────
    build-essential
    linux-headers-amd64
    timeshift
    curl
    wget
    git
    rtkit
    unzip
    zip
    jq
    bc
    xdg-user-dirs
    xdg-utils

    # ─── NETWORK ───────────────────────────────────────────────────────
    network-manager
    
    # ─── AUDIO ─────────────────────────────────────────────────────────
    pulseaudio
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

echo "Install Pakages..."
for pkg in "${package_list[@]}"; do
    install_package "$pkg"
done
echo "Done ."

sudo cp -r "$home_dir/.themes/Gruvbox-Dark-Medium" /usr/share/themes/
sudo cp -r "$home_dir/.themes/Gruvbox-Dark-Medium-xhdpi/" /usr/share/themes/
sudo cp -r "$home_dir/.themes/Gruvbox-Dark-Medium-hdpi/" /usr/share/themes/

sudo cp -r "$home_dir/.local/share/wallpapers/Gruvbox" /usr/share/wallpapers/
sudo cp -f "$home_dir/.config/miscellaneous/lightdm/lightdm.conf" /etc/lightdm/

sudo cp -r "$home_dir/.themes/Gruvbox-Light" /usr/share/themes/
sudo cp -r "$home_dir/.themes/Gruvbox-Light-xhdpi/" /usr/share/themes/
sudo cp -r "$home_dir/.themes/Gruvbox-Light-hdpi/" /usr/share/themes/

sudo cp -r "$home_dir/.icons/"* /usr/share/icons/

echo "Final setup script, have a good day."
