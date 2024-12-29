#!/bin/bash

# Function to detect package manager (apt for Debian/Ubuntu, pacman for Arch)
detect_package_manager() {
    if command -v pacman &> /dev/null; then
        PACKAGE_MANAGER="pacman"
        PACKAGE_COMMAND="sudo pacman -S --noconfirm"
    elif command -v apt &> /dev/null; then
        PACKAGE_MANAGER="apt"
        PACKAGE_COMMAND="sudo apt install -y"
    else
        echo "No supported package manager found. Please install either pacman or apt."
        exit 1
    fi
}

# Detect the package manager
detect_package_manager

echo "Would you like to install Bluetooth services? (y/n)"
read response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Installing Bluetooth services..."
    if [ "$PACKAGE_MANAGER" = "pacman" ]; then
        # Arch-based systems
        sudo pacman -S --noconfirm bluez blueman
        sudo systemctl enable bluetooth
    elif [ "$PACKAGE_MANAGER" = "apt" ]; then
        # Debian-based systems
        sudo apt install -y bluez blueman
        sudo systemctl enable bluetooth
    fi
    echo "Bluetooth services installed."
elif [[ "$response" =~ ^[Nn]$ ]]; then
    echo "Bluetooth services will not be installed."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
