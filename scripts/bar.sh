#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/tundra

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  # printf "^c$black^ ^b$green^ CPU"
  printf "^c$black^ ^b$green^ cpu"
  printf "^c$white^ ^b$grey^ $cpu_val ^b$black^"
}

battery() {
  val=$(cat /sys/class/power_supply/BAT0/capacity)

  printf "^c$black^ ^b$red^ bat"
  printf "^c$white^ ^b$grey^ $val%% ^b$black^"
}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  mem_avail_mb=$(( $(awk '/MemAvailable:/ {print $2}' /proc/meminfo) / 1024 ))
  mem_total_mb=$(( $(awk '/MemTotal:/ {print $2}' /proc/meminfo) / 1024 ))
  mem_perc=$(awk -v a="$mem_total_mb" -v b="$mem_avail_mb" 'BEGIN { printf("%.1f", (a-b)/a*100) }')
  printf "^c$black^ ^b$red^ mem"
  printf "^c$white^ ^b$grey^%s%%" "$mem_perc"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%H:%M')  "
}

while true; do
    sleep 1 && xsetroot -name "$(cpu)$(mem)$(battery)$(clock)"
done
