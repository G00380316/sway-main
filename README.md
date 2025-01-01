
## Wayland compositor

Assuming you have already installed a minimal Arch-based system.
The series of shell scripts are intended to facilitate installing popular window managers.

Within the install.sh file, you can choose to install the following window managers:

* sway
* hyprland

**User can select between vanilla(non-customized) and completely customized (my personal customization)**

# Installation

```
sudo pacman -S wget

wget https://github.com/G00380316/ArchDispManConf/raw/main/clone.sh
wget https://github.com/G00380316/ArchDispManConf/raw/main/install.sh

chmod +x install.sh

./install.sh

rm clone.sh
rm install.sh

```

Recently, I have been thinking about getting a jump on adding a window manager for Wayland.  Fortunately, there is a good "compositor" for this purpose.
Added scripts:

* nwg-look - installs an lxappearance program to use GTK themes and icons in Wayland.
* rofi-wayland - designed to behave like rofi(xorg) but in Wayland.

NOTE:  The recommended login manager will be gdm3 or sddm.
