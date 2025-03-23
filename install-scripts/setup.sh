#!/bin/bash

# Function to install vanilla sway
install_vanilla_sway() {
    echo "Installing vanilla sway..."
    bash ./vanilla_sway.sh
}

# Function to install customized swayWM
install_custom_sway() {
    echo "Installing G00380316 customized sway..."
    bash ./custom_sway.sh
}

# Function to install vanilla hyprland
install_vanilla_hyprland() {
    echo "Installing vanilla hyprland..."
    bash ./vanilla_hyprland.sh
}

# Function to install customized hyprland
install_custom_hyprland() {
    echo "Installing G00380316 customized hyprland..."
    bash ./custom_hyprland.sh
}

prompt_installation_choice() {
    local wm_name="$1"
    echo "$wm_name Installation"
    echo "1. Install $wm_name with no customization"
    echo "2. Install $wm_name with G00380316 customized"
    echo "Or ENTER to skip"
    read -r choice

    case "$choice" in
        1)
            echo "Installing $wm_name with no customization..."
            ;;
        2)
            echo "Installing $wm_name with G00380316 customized..."
            ;;
        *)
            echo "Skipping installation of $wm_name."
            ;;
    esac

    # Adding a couple of line returns
    echo -e "\n"
}

# Main script starts here
# Array to store user choices
declare -A choices

# Function to prompt for Zsh installation
prompt_zsh_installation() {
    echo "Zsh is included in the postinstall. Do you want to proceed with installing Zsh? (y/n)"
    read -r zsh_choice
    if [[ "$zsh_choice" == "y" || "$zsh_choice" == "Y" ]]; then
        echo "Running Post Script..."
        # Post install step (if required)
bash ./postinstall.sh
echo "Post installation completed."
    else
        echo "Skipping Zsh installation."
    fi
}

# Prompt for each window manager and store choices in the array
prompt_and_store_choice() {
    local wm_name="$1"
    prompt_installation_choice "$wm_name"
    choices["$wm_name"]=$choice
}

# Prompt for sway installation
prompt_and_store_choice "sway"
prompt_and_store_choice "hyprland"


# Install based on user choices stored in the array
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
                *)
                    echo "Installation function not defined for $wm_name"
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
                *)
                    echo "Installation function not defined for $wm_name"
                    ;;
            esac
            ;;
        *)
            echo "Skipping $wm_name installation..."
            ;;
    esac
done

echo -e "\nAll installations completed."

# Prompt for Zsh installation
prompt_zsh_installation

