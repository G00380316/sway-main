#!/bin/bash

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Attempting to install Git..."

    # Use pacman to install git
    if command -v pacman &> /dev/null; then
        sudo pacman -Sy
        sudo pacman -S git --noconfirm
    else
        echo "Cannot install Git automatically using pacman. Please install Git manually and run this script again."
        exit 1
    fi

    # Check again if git is installed after attempting to install
    if ! command -v git &> /dev/null; then
        echo "Git installation failed. Please install Git manually and run this script again."
        exit 1
    fi
fi

echo "Git is installed. Continuing with the script..."

# Check if git is installed
if ! command -v yay &> /dev/null; then
    echo "Yay is not installed. Attempting to install Yay..."

    # Use pacman to install yay
    if command -v pacman &> /dev/null; then
        git clone https://aur.archlinux.org/yay.git
        mv yay $HOME/.config
        cd $HOME/.config/yay
        makepkg -si --noconfirm
    else
        echo "Cannot install Yay automatically using pacman. Please install Yay manually and run this script again."
        exit 1
    fi

    # Check again if git is installed after attempting to install
    if ! command -v yay &> /dev/null; then
        echo "Yay installation failed. Please install Yay manually and run this script again."
        exit 1
    fi
fi

# Clone the repository into the home directory
git clone https://github.com/G00380316/ArchDispManConf.git

clear

echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+
 | | |G|0|0|3|8|0|3|1|6| | |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+
 |c|u|s|t|o|m| |s|c|r|i|p|t|
 +-+-+-+-+-+-+ +-+-+-+-+-+-+
"

# Make setup.sh executable (if needed, though it's typically already executable)
# chmod +x setup.sh packages.sh

# Run the setup script
bash ~/ArchDispManConf/install_scripts/setup.sh

bash ~/ArchDispManConf/install_scripts/dev.sh

# Run the extra packages
bash ~/ArchDispManConf/install_scripts/packages.sh

echo "Make sure a Display Manager is installed"

# make sure gdm3 is installed
bash ~/ArchDispManConf/install_scripts/gdm.sh

# add bashrc question
bash ~/ArchDispManConf/install_scripts/add_bashrc.sh

bash ~/ArchDispManConf/install_scripts/printers.sh

bash ~/ArchDispManConf/install_scripts/bluetooth.sh

sudo pacman -Rns $(pacman -Qdtq)
yay -Rns $(yay -Qdtq)

printf "\e[1;32mYou can now reboot! Thanks you.\e[0m\n"

