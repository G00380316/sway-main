#!/bin/bash

# Function to detect the package manager
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

# Function to detect the package manager
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

echo "Would you like to run automated Clean-up? (y/n)"
read response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Automating some for you..."
        echo "Removing some dir..."
            sudo rm -rf ~/go
            sudo rm -rf ~/JetBrainsMono
            sudo rm -rf ~/install.sh
            sudo rm -rf ~/clone.sh
        echo "Dirs removed!"
        echo "Removing unwanted extra packages..."
            sudo pacman -Rns $(pacman -Qdtq)
            yay -Rns $(yay -Qdtq)
        echo "Removed unwanted extra packages!"
        echo "Building Neovim Plugins"
            cd ~/.local/share/nvim/lazy/command-t/lua/wincent/commandt/lib
            make clean
            make
        echo "Built Neovim Plugins!"
        echo "Building Waybar Plugins"
            cd ~/.config/waybar/waybar-module-pomodoro/
            cargo build
        echo "Built Waybar Plugins!"
        echo "Checking if SDDM is installed..."
            # Detect the package manager
        detect_package_manager

        # Check if GDM3 is installed and enabled
        check_gdm() {
            service_active_and_enabled gdm
        }

        # Check if SDDM is installed and enabled
        check_sddm() {
            service_active_and_enabled sddm
        }

        # Check if LightDM is installed and enabled
        check_lightdm() {
            service_active_and_enabled lightdm
        }

        # Check if LXDM is installed and enabled
        check_lxdm() {
            service_active_and_enabled lxdm
        }

        # Check if Ly is installed and enabled
        check_ly() {
            service_active_and_enabled ly
        }

        # Check if SLiM is installed and enabled
        check_slim() {
            service_active_and_enabled slim
        }

        # Function to ask if user wants to enable SDDM if another DM is installed
        ask_install_sddm() {
            read -p "SDDM is recommended. Do you want to enable it? (y/n): " answer
            case $answer in
                [yY])
                    sudo systemctl disable ly
                    sudo systemctl disable slim
                    sudo systemctl disable lxdm
                    sudo systemctl disable lightdm
                    sudo systemctl disable gdm
            

                    enable_sddm
                    ;;
                *)
                    echo "Okay, exiting."
                    exit 0
                    ;;
            esac
        }

        enable_sddm() {
            sudo systemctl enable sddm
            echo "SDDM h enabled."
        }

        echo "Making some dirs..."
            mkdir -p ~/Pictures/ScreenShots/
        echo "Made new dirs!"
    echo "Automation done!!! Everything should be installed and tidy!"
elif [[ "$response" =~ ^[Nn]$ ]]; then
    echo "Automation will not be run."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
