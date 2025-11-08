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
    xrdb merge ~/.config/chadwm/.Xresources-4k27
	feh --bg-fill --randomize ~/Pictures/wall/* &
	~/Documents/Snipaste-2.10.8-x86_64.AppImage &
fi

# Ubuntu aarch64 specific
if [ "$DISTRO" = "ubuntu" ] && [ "$ARCH" = "aarch64" ]; then
    xrdb merge ~/.config/chadwm/.Xresources-4k27
    xbacklight -set 10 & # Commented out, usually not needed for desktop PCs
    # set 120hz
    xrandr --output eDP-1 --mode 0x4b
    xrandr --output DP-1 --mode 3840x2160 --rate 60 --right-of eDP-1 --auto
	feh --bg-fill --randomize /usr/share/backgrounds/* &

    flameshot &

    # set touchpad natutral scrolling
    xinput set-prop 10 "libinput Natural Scrolling Enabled" 1
    xinput set-prop 10 "libinput Tapping Enabled" 1
    xinput set-prop 10 "libinput Click Method Enabled" 1 0
    xinput set-prop 10 "libinput Disable While Typing Enabled" 1

    gestures start &
fi

# Arch AMD64 specific
if [ "$DISTRO" = "arch" ] && [ "$ARCH" = "amd64" ]; then
    xrdb merge ~/.config/chadwm/.Xresources-4k27
	feh --bg-fill --randomize ~/Pictures/* &
	Snipaste &
fi

picom &
redshift -l 30.6:114.3 -t 6500:4000 & # Auto night mode for Wuhan location
pot &
fcitx5 &
dunst &
nm-applet &
blueman-applet &
dbus-launch pasystray &

# Start bar.sh and track its PID
dash ~/.config/chadwm/scripts/bar.sh &
BAR_PID=$!

# Run chadwm in a loop
while type chadwm >/dev/null; do
  chadwm && continue || break
done

# Kill bar.sh when chadwm exits
kill $BAR_PID 2>/dev/null
