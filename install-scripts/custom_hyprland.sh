#!/bin/bash

# Main list of packages
packages=(
    "hyprland"
    "waybar"
    "swaylock"
    "swayidle"
    "swaync"
)

# AUR packages
yay_packages=()

# Function to read common packages from a file
read_packages_from_file() {
    local file="$1"
    local -n array_ref="$2"
    if [ -f "$file" ]; then
        while read -r pkg; do
            [ -n "$pkg" ] && array_ref+=("$pkg")
        done < "$file"
    else
        echo "File not found: $file"
        exit 1
    fi
}

# Read package lists
read_packages_from_file "$HOME/Arch_Install/install_scripts/common_packages.txt" packages
read_packages_from_file "$HOME/Arch_Install/install_scripts/yay_common_packages.txt" yay_packages

# Function to install pacman packages if they are not already installed
install_packages() {
    local pkgs=("$@")
    local missing_pkgs=()

    for pkg in "${pkgs[@]}"; do
        if ! pacman -Q "$pkg" &>/dev/null; then
            missing_pkgs+=("$pkg")
        fi
    done

    if [ ${#missing_pkgs[@]} -gt 0 ]; then
        echo "Installing missing pacman packages: ${missing_pkgs[@]}"
        sudo pacman -S --noconfirm "${missing_pkgs[@]}" || {
            echo "Failed to install some packages. Continuing."
        }
    else
        echo "All pacman packages are already installed."
    fi
}

# Function to install yay packages if they are not already installed
install_yay_packages() {
    local pkgs=("$@")
    local missing_pkgs=()

    for pkg in "${pkgs[@]}"; do
        if ! yay -Q "$pkg" &>/dev/null; then
            missing_pkgs+=("$pkg")
        fi
    done

    if [ ${#missing_pkgs[@]} -gt 0 ]; then
        echo "Installing missing yay packages: ${missing_pkgs[@]}"
        yay -S --noconfirm "${missing_pkgs[@]}" || {
            echo "Failed to install some AUR packages. Continuing."
        }
    else
        echo "All yay packages are already installed."
    fi
}

# Remove unwanted packages
if pacman -Q wofi &>/dev/null; then
    sudo pacman -Rns --noconfirm wofi
fi

# Install packages
install_packages "${packages[@]}"
install_yay_packages "${yay_packages[@]}"

# Enable necessary services
sudo pacman -Rns --noconfirm pulseaudio pulseaudio-alsa
systemctl --user daemon-reload
systemctl --user restart xdg-desktop-portal-wlr.service
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid
sudo systemctl --user enable --now pipewire pipewire-pulse
xdg-mime default thunar.desktop inode/directory application/x-gnome-saved-search
sudo systemctl enable --now tlp

# Update user directories
xdg-user-dirs-update

# Install Nerd Fonts
bash ~/Arch_Install/install_scripts/nerdfonts.sh

# Install NWG Look
bash ~/Arch_Install/install_scripts/nwg-look

# Install Rofi-Wayland
sudo pacman -S --noconfirm rofi 

# Move custom configuration files
rsync -a --progress ~/Arch_Install/configs/ ~/.config/

# Add GTK theme and icon theme
bash ~/Arch_Install/colorschemes/purple.sh
