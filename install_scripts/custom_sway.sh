#!/bin/bash

# Main list of packages
packages=(
    "sway"
    "waybar"
    "swaylock"
    "swayidle"
    "swaybg"
    "swaync"
)

yay_packages=()

# Function to read common packages from a file
read_common_packages() {
    local common_file="$1"
    if [ -f "$common_file" ]; then
        packages+=( $(< "$common_file") )
    else
        echo "Common packages file not found: $common_file"
        exit 1
    fi
}

# Function to read common packages from a file
read_yay_common_packages() {
    local yay_common_file="$1"
    if [ -f "$yay_common_file" ]; then
        yay_packages+=( $(< "$yay_common_file") )
    else
        echo "Common packages file not found: $common_file"
        exit 1
    fi
}

# Read common packages from file
read_yay_common_packages "$HOME/ArchDispManConf/install_scripts/yay_common_packages.txt"
# Read common packages from file
read_common_packages "$HOME/ArchDispManConf/install_scripts/common_packages.txt"

# Function to install packages if they are not already installed
yay_install_packages() {
    local pkgs=("$@")
    local missing_pkgs=()

    #Handling uninstalls
    yay -R --noconfirm wofi

    # Check if each package is installed
    for pkg in "${pkgs[@]}"; do
        if ! yay -Q "$pkg" &>/dev/null; then
            missing_pkgs+=("$pkg")
        fi
    done

    # Install missing packages
    if [ ${#missing_pkgs[@]} -gt 0 ]; then
        echo "Installing missing packages: ${missing_pkgs[@]}"
        sudo yay -S --noconfirm "${missing_pkgs[@]}"
        if [ $? -ne 0 ]; then
            echo "Failed to install some packages. Exiting."
            exit 1
        fi
    else
        echo "All required packages are already installed."
    fi
}

# Function to install packages if they are not already installed
install_packages() {
    local pkgs=("$@")
    local missing_pkgs=()

    # Check if each package is installed
    for pkg in "${pkgs[@]}"; do
        if ! pacman -Q "$pkg" &>/dev/null; then
            missing_pkgs+=("$pkg")
        fi
    done

    # Install missing packages
    if [ ${#missing_pkgs[@]} -gt 0 ]; then
        echo "Installing missing packages: ${missing_pkgs[@]}"
        sudo pacman -S --noconfirm "${missing_pkgs[@]}"
        if [ $? -ne 0 ]; then
            echo "Failed to install some packages. Exiting."
            exit 1
        fi
    else
        echo "All required packages are already installed."
    fi
}

# Call function to install packages
install_packages "${packages[@]}"
yay_install_packages "${yay_packages[@]}"

# Enable/Disable necessary system services
sudo pacman -Rns --noconfirm pulseaudio pulseaudio-alsa
systemctl --user daemon-reload
systemctl --user restart xdg-desktop-portal-wlr.service
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid
sudo systemctl --user enable --now pipewire pipewire-pulse
xdg-mime default thunar.desktop inode/directory application/x-gnome-saved-search
xfdesktop --load
sudo systemctl enable --now tlp

# Update user directories
xdg-user-dirs-update

# Create Screenshot directory
mkdir -p ~/Screenshots/

# Install Nerd Fonts
bash ~/ArchDispManConf/install_scripts/nerdfonts.sh

# Install NWG Look
bash ~/ArchDispManConf/install_scripts/nwg-look

# Install Rofi-Wayland
bash ~/ArchDispManConf/install_scripts/rofi-wayland

# Move custom configuration files
cp -r ~/ArchDispManConf/configs/scripts/ ~
cp -r ~/ArchDispManConf/configs/sway/ ~/.config/
cp -r ~/ArchDispManConf/configs/swaync/ ~/.config/
cp -r ~/ArchDispManConf/configs/waybar/ ~/.config/
cp -r ~/ArchDispManConf/configs/rofi/ ~/.config/
cp -r ~/ArchDispManConf/configs/kitty/ ~/.config/
cp -r ~/ArchDispManConf/configs/backgrounds/ ~/.config/

# Add GTK theme and icon theme
bash ~/ArchDispManConf/colorschemes/purple.sh
