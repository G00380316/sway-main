#!/bin/zsh

# Function to install selected packages using pacman
install_packages() {
    sudo pacman -S --noconfirm --needed "$@"
}

# Function to read and validate input for package selections
read_selection() {
    local prompt=$1
    local options=("${!2}")

    echo "$prompt"
    for i in "${!options[@]}"; do
        echo "$((i+1)). ${options[i]}"
    done
    read -rp "Enter the numbers of your choices (space-separated): " selection

    selected=()
    for index in $selection; do
        if (( index >= 1 && index <= ${#options[@]} )); then
            selected+=("${options[index-1]}")
        fi
    done

    echo "${selected[@]}"
}

# File Managers
file_managers=("thunar" "pcmanfm" "krusader" "nautilus" "nemo" "dolphin" "ranger" "nnn" "lf")
selected_file_managers=($(read_selection "Choose File Managers to install:" file_managers[@]))

# Graphics
graphics=("gimp" "flameshot" "eog" "sxiv" "qimgv" "inkscape" "scrot")
selected_graphics=($(read_selection "Choose Graphics applications to install:" graphics[@]))

# Terminals
terminals=("alacritty" "gnome-terminal" "kitty" "konsole" "terminator" "xfce4-terminal")
selected_terminals=($(read_selection "Choose Terminals to install:" terminals[@]))

# Text Editors
text_editors=("geany" "kate" "gedit" "l3afpad" "mousepad" "pluma")
selected_text_editors=($(read_selection "Choose Text Editors to install:" text_editors[@]))

# Multimedia
multimedia=("mpv" "vlc" "audacity" "kdenlive" "obs-studio" "rhythmbox" "ncmpcpp" "mkvtoolnix-gui")
selected_multimedia=($(read_selection "Choose Multimedia applications to install:" multimedia[@]))

# Utilities
utilities=("gparted" "gnome-disk-utility" "neofetch" "nitrogen" "numlockx" "galculator" "cpu-x" "udns-utils" "whois" "curl" "tree" "btop" "htop" "bat" "brightnessctl" "redshift")
selected_utilities=($(read_selection "Choose Utilities applications to install:" utilities[@]))

# Install selected packages
install_packages "${selected_file_managers[@]}" "${selected_graphics[@]}" "${selected_terminals[@]}" "${selected_text_editors[@]}" "${selected_multimedia[@]}" "${selected_utilities[@]}"
