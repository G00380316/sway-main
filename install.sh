#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Ensure script is run as root
# if [ "$EUID" -ne 0 ]; then
#     echo "Please run this script as root."
#     exit 1
# fi

# Check if git is installed, else attempt installation
if ! command_exists git; then
    echo "Git is not installed. Attempting to install Git..."
    if command_exists pacman; then
        pacman -Sy --noconfirm
        pacman -S --noconfirm git
        echo "Git installation successful. Run this script again to use git."
        exit 1
    else
        echo "Cannot install Git automatically. Please install Git manually."
        exit 1
    fi
fi

echo "Git is installed. Continuing with the script..."

# Check if yay is installed, else attempt installation
if ! command_exists yay; then
    echo "Yay is not installed. Attempting to install Yay..."
    if command_exists pacman; then
        git clone https://aur.archlinux.org/yay.git $HOME/.config/yay
        cd $HOME/.config/yay || exit 1
        makepkg -si --noconfirm
        echo "Yay installation successful. Run this script again to use yay."
        exit 1
    else
        echo "Cannot install Yay automatically. Please install Yay manually."
        exit 1
    fi
fi

echo "Yay is installed. Continuing with the script..."

# Clone the repository into the home directory
chmod +x ~/clone.sh
bash ~/clone.sh

echo "cloned the git repo"

DIRECTORY="Arch_Install"

if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory $DIRECTORY does not exist. Run the script again! ;)"
    exit 1
fi

echo "Directory $DIRECTORY exists. Continuing..."
sleep 3
clear

echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+
 | | |G|0|0|3|8|0|3|1|6| | |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+
 |c|u|s|t|o|m| |s|c|r|i|p|t|
 +-+-+-+-+-+-+ +-+-+-+-+-+-+
"

cd ~/Arch_Install/install_scripts/ || exit 1

# Make scripts executable
chmod +x *.sh

# Available scripts
SCRIPTS=("setup.sh" "devs.sh" "packages.sh" "displaymanager.sh" "add_bashrc.sh" "printers.sh" "bluetooth.sh" "util.sh" "cleanup.sh" "displaylinkinstall.sh")

# Display menu
echo "Select scripts to run (multiple selections allowed, separate by space):"
echo "0) All"
for i in "${!SCRIPTS[@]}"; do
    echo "$((i + 1))) ${SCRIPTS[$i]}"
done

echo -n "Enter your choice: "
read -ra CHOICES

# Function to run a script with high privileges
run_script() {
    echo "Running $1..."
    sudo bash ./$1
}

# Run selected scripts
if [[ "${CHOICES[*]}" =~ "0" ]]; then
    for script in "${SCRIPTS[@]}"; do
        run_script "$script"
    done
else
    for choice in "${CHOICES[@]}"; do
        index=$((choice - 1))
        if [ "$index" -ge 0 ] && [ "$index" -lt "${#SCRIPTS[@]}" ]; then
            run_script "${SCRIPTS[$index]}"
        else
            echo "Invalid choice: $choice"
        fi
    done
fi

# Run wallpapers and AniInstall if available
if [ -f "./AniInstall.sh" ]; then
    read -p "Do you want to run Additional Install for Animations? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
        if [ -d "./wallpapers/" ]; then
            cp -r ./wallpapers/ ~/Pictures/
        fi
        if [ -f "./wallpapers.sh" ]; then
            sudo bash ./wallpapers.sh
        fi
        sudo bash ./AniInstall.sh
    fi
fi

printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"
