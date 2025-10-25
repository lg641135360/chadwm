#!/bin/sh

# Execute initialization only on first run
xrdb merge ~/.config/chadwm/.Xresources
xbacklight -set 10 & # Commented out, usually not needed for desktop PCs
# set 120hz
xrandr --output eDP-1 --mode 0x4b
xrandr --output DP-1 --mode 3840x2160 --rate 60
Xrandr --output DP-1 --right-of eDP-1 --auto

# set touchpad natutral scrolling
xinput set-prop 10 "libinput Natural Scrolling Enabled" 1
xinput set-prop 10 "libinput Tapping Enabled" 1
xinput set-prop 10 "libinput Click Method Enabled" 1 0
xinput set-prop 10 "libinput Disable While Typing Enabled" 1

feh --bg-fill --randomize /usr/share/backgrounds/* &
picom &
redshift -l 30.6:114.3 -t 6500:4000 & # Auto night mode for Wuhan location
pot &
flameshot &
fcitx5 &
dunst &
nm-applet &
blueman-applet &
dbus-launch pasystray &

gestures start &
dash ~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
