#!/bin/zsh

# Main list of packages
packages=(
    "sway"
    "waybar" 
    "swaylock"
    "swayidle"
    "swaybg"
    "sway-notification-center"
)

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

# Read common packages from file
read_common_packages "$HOME/sway/install_scripts/common_packages.txt"

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
        sudo pacman -Sy --noconfirm "${missing_pkgs[@]}"
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

# Enable necessary system services
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

# Update user directories
xdg-user-dirs-update

# Create Screenshot directory
mkdir -p ~/Screenshots/

# Install Nerd Fonts
zsh ~/sway/install_scripts/nerdfonts.sh

# Install NWG Look
zsh ~/sway/install_scripts/nwg-look

# Install Rofi-Wayland
zsh ~/sway/install_scripts/rofi-wayland

# Move custom configuration files
\cp -r ~/sway/configs/scripts/ ~
\cp -r ~/sway/configs/sway/ ~/.config/
\cp -r ~/sway/configs/swaync/ ~/.config/
\cp -r ~/sway/configs/waybar/ ~/.config/
\cp -r ~/sway/configs/rofi/ ~/.config/
\cp -r ~/sway/configs/kitty/ ~/.config/
\cp -r ~/sway/configs/backgrounds/ ~/.config/

# Add GTK theme and icon theme
zsh ~/sway/colorschemes/purple.sh
