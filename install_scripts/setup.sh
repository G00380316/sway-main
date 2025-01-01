#!/bin/bash

# Function to install vanilla sway
install_vanilla_sway() {
    echo "Installing vanilla sway..."
    bash ~/ArchDispManConf/install_scripts/vanilla_sway.sh
}

# Function to install customized swayWM
install_custom_sway() {
    echo "Installing G00380316 customized sway..."
    bash ~/ArchDispManConf/install_scripts/custom_sway.sh
}

# Function to install vanilla hyprland
install_vanilla_hyprland() {
    echo "Installing vanilla hyprland..."
    bash ~/ArchDispManConf/install_scripts/vanilla_hyprland.sh
}

# Function to install customized hyprland
install_custom_hyprland() {
    echo "Installing G00380316 customized hyprland..."
    bash ~/ArchDispManConf/install_scripts/custom_hyprland.sh
}

prompt_installation_choice() {
    local wm_name="$1"
    echo "$wm_name Installation"
    echo "1. Install vanilla $wm_name"
    echo "2. Install customized $wm_name"
    echo "Or press ENTER to skip"
    read -r choice

    case "$choice" in
        1)
            echo "Installing vanilla $wm_name..."
            ;;
        2)
            echo "Installing customized $wm_name..."
            ;;
        *)
            echo "Skipping installation of $wm_name."
            ;;
    esac

    # Return the choice
    echo "$choice"
}

# Function to prompt for Zsh installation
prompt_zsh_installation() {
    echo "Zsh is included in the postinstall. Do you want to proceed with installing Zsh? (y/n)"
    read -r zsh_choice
    if [[ "$zsh_choice" == "y" || "$zsh_choice" == "Y" ]]; then
        echo "Running Post Script..."
        # Post install step (if required)
bash ~/ArchDispManConf/install_scripts/postinstall.sh
echo "Post installation completed."
    else
        echo "Skipping Zsh installation."
    fi
}

# Array to store user choices
declare -A choices

# Prompt and store user choices for Sway and Hyprland installations
for wm_name in "sway" "hyprland"; do
    choice=$(prompt_installation_choice "$wm_name")
    choices["$wm_name"]="$choice"
done

# Execute installation steps based on user choices
for wm_name in "${!choices[@]}"; do
    case "${choices[$wm_name]}" in
        1)
            case "$wm_name" in
                "sway")
                    install_vanilla_sway
                    ;;
                "hyprland")
                    install_vanilla_hyprland
                    ;;
            esac
            ;;
        2)
            case "$wm_name" in
                "sway")
                    install_custom_sway
                    ;;
                "hyprland")
                    install_custom_hyprland
                    ;;
            esac
            ;;
        *)
            echo "Skipping $wm_name installation..."
            ;;
    esac
done

echo "All installations completed."

# Prompt for Zsh installation
prompt_zsh_installation

