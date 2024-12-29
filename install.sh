#!/bin/zsh

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Attempting to install Git..."
    
    # Use apt to install git
    if command -v apt &> /dev/null; then
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
# Add further commands here after ensuring Git is installed



# Clone the repository into the home directory
git clone https://github.com/G00380316/sway ~/sway


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
zsh ~/sway/install_scripts/setup.sh

clear

# Run the extra packages
zsh ~/sway/install_scripts/packages.sh

clear

echo "Make sure a Display Manager is installed"

# make sure gdm3 is installed
zsh ~/sway/install_scripts/gdm.sh

clear

# add bashrc question
zsh ~/sway/install_scripts/add_bashrc.sh

clear 

zsh ~/sway/install_scripts/printers.sh

clear 

zsh ~/sway/install_scripts/bluetooth.sh
sudo pacman -Rns $(pacman -Qdtq)
yay -Rns $(yay -Qdtq)

printf "\e[1;32mYou can now reboot! Thanks you.\e[0m\n"

