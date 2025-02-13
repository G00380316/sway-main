#!/bin/bash


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
    echo "Automation done!!! Everything should be installed and tidy!"
elif [[ "$response" =~ ^[Nn]$ ]]; then
    echo "Automation will not be run."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi
