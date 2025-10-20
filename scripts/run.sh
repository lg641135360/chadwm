#!/bin/sh

# Detect Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO="unknown"
fi

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64)
        ARCH="aarch64"
        ;;
    *)
        ARCH="unknown"
        ;;
esac

# Ubuntu AMD64 specific
if [ "$DISTRO" = "ubuntu" ] && [ "$ARCH" = "amd64" ]; then
    xrdb merge ~/.config/chadwm/.Xresources-2x2k24
	feh --bg-fill --randomize ~/Pictures/wall/* &
	~/Documents/Snipaste-2.10.8-x86_64.AppImage &
fi

# Arch AMD64 specific
if [ "$DISTRO" = "arch" ] && [ "$ARCH" = "amd64" ]; then
    xrdb merge ~/.config/chadwm/.Xresources-2x2k24
	feh --bg-fill --randomize ~/Pictures/* &
	~/Documents/Snipaste-2.10.8-x86_64.AppImage &
fi

picom &
fcitx5 &
redshift -l 30.6:114.3 -t 6500:4000 & # Auto night mode for Wuhan location

pot &
udiskie -t & # automount usb drives
pasystray & # volume control tray icon
nm-applet & # network manager tray icon
dunst & # notification daemon

dash ~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
