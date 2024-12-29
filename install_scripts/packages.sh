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
    read -rp "Selection: " selection
    
    selected=()
    for index in $selection; do
        # Validate if the index is within range
        if (( index >= 1 && index <= ${#options[@]} )); then
            selected+=("${options[index-1]}")
        else
            echo "Invalid selection: $index. Please choose a valid index."
            return 1
        fi
    done
    
    echo "${selected[@]}"
}

# File Managers
file_managers=("thunar" "pcmanfm" "krusader" "nautilus" "nemo" "dolphin" "ranger" "nnn" "lf")
selected_file_managers=($(read_selection "Choose File Managers to install (space-separated list, e.g., 1 3 5):" file_managers))

# Graphics
graphics=("gimp" "flameshot" "eog" "sxiv" "qimgv" "inkscape" "scrot")
selected_graphics=($(read_selection "Choose graphics applications to install (space-separated list, e.g., 1 3 5):" graphics))

# Terminals
terminals=("alacritty" "gnome-terminal" "kitty" "konsole" "terminator" "xfce4-terminal")
selected_terminals=($(read_selection "Choose Terminals to install (space-separated list, e.g., 1 3):" terminals))

# Text Editors
text_editors=("geany" "kate" "gedit" "l3afpad" "mousepad" "pluma")
selected_text_editors=($(read_selection "Choose Text Editors to install (space-separated list, e.g., 1 3 5):" text_editors))

# Multimedia
multimedia=("mpv" "vlc" "audacity" "kdenlive" "obs-studio" "rhythmbox" "ncmpcpp" "mkvtoolnix-gui")
selected_multimedia=($(read_selection "Choose Multimedia applications to install (space-separated list, e.g., 1 3 5):" multimedia))

# Utilities
utilities=("gparted" "gnome-disk-utility" "neofetch" "nitrogen" "numlockx" "galculator" "cpu-x" "udns-utils" "whois" "curl" "tree" "btop" "htop" "bat" "brightnessctl" "redshift")
selected_utilities=($(read_selection "Choose utilities applications to install (space-separated list, e.g., 1 3 5):" utilities))

# Install selected packages
install_packages "${selected_file_managers[@]}" "${selected_graphics[@]}" "${selected_terminals[@]}" "${selected_text_editors[@]}" "${selected_multimedia[@]}" "${selected_utilities[@]}"
