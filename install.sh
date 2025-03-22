#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if git is installed, else attempt installation
if ! command_exists git; then
    echo "Git is not installed. Attempting to install Git..."
    if command_exists pacman; then
        pacman -Sy --noconfirm
        pacman -S --noconfirm git
        if command_exists git; then 
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
        if command_exists yay; then
        echo "Yay installation successful. Run this script again to use yay."
        exit 1
    else
        echo "Cannot install Yay automatically. Please install Yay manually."
        exit 1
    fi
fi

echo "Yay is installed. Continuing with the script..."

git clone https://github.com/G00380316/Arch_Install.git

if [ -d "Arch_Install" ]; then
    echo "Arch_Install directory cloned..."
else
    echo "Arch_Install directory clone failed, try runnning script again..."
fi

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

cd ~/Arch_Install/install-scripts/ || exit 1

# Make scripts executable
chmod +x *.sh

# Available scripts
SCRIPTS=("setup.sh" "devs.sh" "packages.sh" "displaymanager.sh" "add_bashrc.sh" "printers.sh" "bluetooth.sh" "util.sh" "cleanup.sh" "displaylinkinstall.sh")

# Display menu
echo "Select scripts to run (multiple selections allowed, separate by space):"
echo "0) All"
echo " "
echo "Type) skip"
echo " "
for i in "${!SCRIPTS[@]}"; do
    echo "$((i + 1))) ${SCRIPTS[$i]}"
done

echo -n "Enter your choice: "
read -ra CHOICES

# Function to run a script
run_script() {
    echo "Running $1..."
    bash ./$1
}

# Run selected scripts
if [[ "${CHOICES[*]}" =~ "0" ]]; then
    for script in "${SCRIPTS[@]}"; do
        run_script "$script"
    done
elif [[ "${CHOICES}" != *"skip"* ]]; then
    for choice in "${CHOICES[@]}"; do
        index=$((choice - 1))
        if [ "$index" -ge 0 ] && [ "$index" -lt "${#SCRIPTS[@]}" ]; then
            run_script "${SCRIPTS[$index]}"
        else
            echo "Invalid choice: $choice"
        fi
    done
fi

cd ~/Arch_Install/

# Run wallpapers and AniInstall if available
if [ -f "./AniInstall.sh" ]; then
    read -p "Do you want to run Additional Install for Animations? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
        if [ -d "./wallpapers/" ]; then
            cp -r ./wallpapers/ ~/Pictures/
        fi
        if [ -f "./wallpapers.sh" ]; then
            bash ./wallpapers.sh
        fi
        bash ./AniInstall.sh
    fi
fi

printf "\e[1;32mYou can now reboot! Thank you. Consider running cleanup Script will tidy and configure some missing pieces\e[0m\n"
