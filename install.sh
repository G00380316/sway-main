#!/bin/bash

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Attempting to install Git..."

    # Use pacman to install git
    if command -v pacman &> /dev/null; then
        sudo pacman -Sy
        sudo pacman -S --noconfirm git

        echo "Git installation successful. Run this script again to use git."

        exit 1
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

        echo "Yay installation successful. Run this script again to use yay."

        exit 1

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
chmod +x ~/clone.sh

bash ~/clone.sh

echo "cloned the git repo"

DIRECTORY="ArchDispManConf"

if [ ! -d "$DIRECTORY" ]; then
  echo "Error: Directory $DIRECTORY does not exist."
  echo "Don't worry run script again!!! ;) "
  exit 1
fi

echo "Directory $DIRECTORY exists. Continuing..."

wait 3

clear

echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+
 | | |G|0|0|3|8|0|3|1|6| | |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+
 |c|u|s|t|o|m| |s|c|r|i|p|t|
 +-+-+-+-+-+-+ +-+-+-+-+-+-+
"
cd ~/ArchDispManConf/install_scripts

# Make setup.sh executable (if needed, though it's typically already executable)
chmod +x setup.sh packages.sh devs.sh gdm.sh add_bashrc.sh printers.sh bluetooth.sh util.sh

# Run the setup script
bash ~/ArchDispManConf/install_scripts/setup.sh

bash ~/ArchDispManConf/install_scripts/devs.sh

# Run the extra packages
bash ~/ArchDispManConf/install_scripts/packages.sh

echo "Make sure a Display Manager is installed"

# make sure gdm3 is installed
bash ~/ArchDispManConf/install_scripts/gdm.sh

# add bashrc question
bash ~/ArchDispManConf/install_scripts/add_bashrc.sh

bash ~/ArchDispManConf/install_scripts/printers.sh

bash ~/ArchDispManConf/install_scripts/bluetooth.sh

bash ~/ArchDispManConf/install_scripts/util.sh

sudo pacman -Rns $(pacman -Qdtq)
yay -Rns $(yay -Qdtq)

echo "
run this if all is good

sudo rm -rf ~/go
sudo rm -rf ~/JetBrainsMono
swww img ~/.config/backgrounds/Luffylying.png

"

printf "\e[1;32mYou can now reboot! Thanks you.\e[0m\n"

