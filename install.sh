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
        echo "Git installation successful. Run this script again to use git."
        exit 1
    else
        echo "Cannot install Git automatically. Please install Git manually."
        exit 1
    fi
fi

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

# Check if whiptail is installed, else attempt installation
if ! command_exists whiptail; then
    echo "Whiptail is not installed. Installing..."
    yay -S --noconfirm libnewt
fi

# Clone the repository into the home directory
chmod +x ~/clone.sh
bash ~/clone.sh

DIRECTORY="Arch_Install"

if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory $DIRECTORY does not exist. Run the script again! ;)"
    exit 1
fi

cd ~/Arch_Install/install-scripts/ || exit 1

# Make scripts executable
chmod +x *.sh

# Available scripts
SCRIPTS=("setup.sh" "devs.sh" "packages.sh" "displaymanager.sh" "add_bashrc.sh" "printers.sh" "bluetooth.sh" "util.sh" "cleanup.sh" "displaylinkinstall.sh")

# Display menu using whiptail
MENU_OPTIONS=(0 "All" "skip" "Skip")
for i in "${!SCRIPTS[@]}"; do
    MENU_OPTIONS+=("$((i + 1))" "${SCRIPTS[$i]}")
done

CHOICES=$(whiptail --title "Select Scripts to Run" \
                --checklist "Choose the scripts to run:" 20 78 10 \
                "${MENU_OPTIONS[@]}" 3>&1 1>&2 2>&3)

# Function to run a script
run_script() {
    echo "Running $1..."
    bash ./$1
}

# Run selected scripts
if [[ "${CHOICES}" =~ "0" ]]; then
    for script in "${SCRIPTS[@]}"; do
        run_script "$script"
    done
elif [[ "${CHOICES}" != *"skip"* ]]; then
    for choice in $CHOICES; do
        index=$((choice - 1))
        if [ "$index" -ge 0 ] && [ "$index" -lt "${#SCRIPTS[@]}" ]; then
            run_script "${SCRIPTS[$index]}"
        else
            echo "Invalid choice: $choice"
        fi
    done
fi

# Run AniInstall if available
if [ -f "./AniInstall.sh" ]; then
    if (whiptail --title "AniInstall" --yesno "Do you want to run Additional Install for Animations?" 8 78); then
        if [ -d "./wallpapers/" ]; then
            cp -r ./wallpapers/ ~/Pictures/
        fi
        if [ -f "./wallpapers.sh" ]; then
            bash ./wallpapers.sh
        fi
        bash ./AniInstall.sh
    fi
fi

printf "\e[1;32mYou can now reboot! Thank you.\e[0m\n"

