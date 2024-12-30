#!/bin/zsh

    # Clone Neovim Configuration Repository
    echo "Cloning Neovim configuration..."
    git clone https://github.com/G00380316/nvim.git
    mv ~/nvim ~/.config

    echo "Cloning tpm for tmux configuration..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    cd ~/
    dircolors -p > ~/.dircolors
    mkdir -p ~/Coding/Projects

    # Move application config folders to .config
    echo "Moving configuration folders to .config directory..."
    cd ArchConfig
    cp -r ~/ArchDispManConf/configs/.zshenv "~/"
    cp -r ~/ArchDispManConf/configs/.zshrc "~/"
    cp -r ~/ArchDispManConf/configs/.p10k.zsh "~/"


echo "Installing JetBrains Nerd Font..."
    # Step 1: Download the Nerd Font
    echo "Downloading JetBrains Nerd Font..."
    FONT_ZIP="JetBrainsMono.zip"
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    curl -LO "$FONT_URL"

    # Step 2: Extract the Font
    echo "Extracting the font..."
    unzip "$FONT_ZIP" -d JetBrainsMono
    rm -rf "$FONT_ZIP"

    # Step 3: Install the Font
    echo "Installing the font..."
    cd ~/.local/share
    mkdir -p fonts
    mv JetBrainsMono ~/.local/share/fonts/
    fc-cache -fv

    # Install Python using pyenv
    echo "Installing pyenv and Python..."
    curl https://pyenv.run | zsh
    echo -e '\n# Pyenv configuration' >> ~/.zshrc
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    source ~/.zshrc
    pyenv install 3.11.4
    pyenv global 3.11.4
    pip install -U hyfetch

    # Install Node.js using nvm
    echo "Installing nvm and Node.js..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | zsh
    source ~/.nvm/nvm.sh
    nvm install node
    nvm use node

    # Install Go
    echo "Installing Go..."
    wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
    source ~/.zshrc

    # Install Rust
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    source ~/.zshrc
    rustup update


# Development Tools
echo "Installing basic development tools..."
sudo pacman -S --noconfirm base-devel curl git github-cli wget lazygit gcc jdk-openjdk ruby

# Flutter Install
git clone https://github.com/flutter/flutter.git -b stable
sudo mv flutter /opt/flutter

# Some dependencies
sudo pacman -S --noconfirm cmake
# To be completely honest most things surrounding the installation of android
# tools for flutter can be done through android Studio just navigate to the
# settings and seach for 'Android SDK'

yay -S --noconfirm android-studio
# yay -S --noconfirm android-sdk android-ndk

flutter doctor

# Install PHP and Lua
echo "Installing PHP and Lua..."
sudo pacman -S --noconfirm php lua

# Runtime dependencies
# Browsing and Other Applications
echo "Installing Neofetch and Neovim"
sudo pacman -S --noconfirm neovim neofetch

# Productivity
sudo pacman -S --noconfirm zoxide tmux

# Install Flatpak and Obsidian,Vesktop,Postman,DbGate,...etc
echo "Installing Flatpak and Obsidian..."
sudo pacman -S --noconfirm flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install vesktop -y
flatpak install dbgate -y
flatpak install obsidian -y
flatpak install blanket -y
flatpak install flathub org.moneymanagerex.MMEX -y
flatpak install flathub dev.bragefuglseth.Keypunch -y
flatpak install flathub net.lugsole.bible_gui -y
flatpak install flathub com.usebruno.Bruno -y
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub org.gnome.Boxes -y
# Important we use flatseal to manager our flatpak apps (Cuase sometimes they don't render properly) [Issue was scaling make sure you dont change your scale from 1]
flatpak install flatseal -y

# Terminal Calculator
sudo pacman -S --noconfirm bc
# Monitor hardware health ( CPU temperatures, fan speeds, voltages, and other system health metrics.)
sudo pacman -S --noconfirm lm_sensors
# Command-line tool for visualizing directory structures in a clear, hierarchical format
sudo pacman -S --noconfirm tree
# Interactive process viewer and system monitor for Unix-like operating systems.
sudo pacman -S --noconfirm htop
# A simple, fast, and user-friendly alternative to the 'find' command. "'fd' -e" 'everthing'
sudo pacman -S --noconfirm fd
# A command-line search tool that recursively searches your current directory for a regex pattern "rg"
sudo pacman -S --noconfirm ripgrep
# Sound utility
sudo pacman -S --noconfirm pavucontrol
# For Display Utility
sudo pacman -S --noconfirm wlr-randr

# Clean up
echo "Cleaning up..."
sudo pacman -Sc --noconfirm

echo "All done! Now run util.sh and displaylinkinstall.sh and look at info.txt"
