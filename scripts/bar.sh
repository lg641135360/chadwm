#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/dracula

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$green^ Cpu"
  printf "^c$white^ ^b$grey^ $cpu_val ^b$black^"
}

pkg_updates() {
  #updates=$({ timeout 20 doas xbps-install -un 2>/dev/null || true; } | wc -l) # void
  updates=$({ timeout 20 checkupdates 2>/dev/null || true; } | wc -l) # arch
  # updates=$({ timeout 20 aptitude search '~U' 2>/dev/null || true; } | wc -l)  # apt (ubuntu, debian etc)

  if [ -z "$updates" ]; then
    printf "  ^c$green^    Fully Updated"
  else
    printf "  ^c$white^    $updates"" updates"
  fi
}

battery() {
  val="$(cat /sys/class/power_supply/BAT0/capacity)"
  printf "^c$black^ ^b$red^ BAT"
  printf "^c$white^ ^b$grey^ $val ^b$black^"

}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  mem_avail_mb=$(( $(awk '/MemAvailable:/ {print $2}' /proc/meminfo) / 1024 ))
  mem_total_mb=$(( $(awk '/MemTotal:/ {print $2}' /proc/meminfo) / 1024 ))
  mem_perc=$(awk -v a="$mem_total_mb" -v b="$mem_avail_mb" 'BEGIN { printf("%.1f", (a-b)/a*100) }')
  printf "^c$black^ ^b$red^ Mem"
  printf "^c$white^ ^b$grey^%s%%" "$mem_perc"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

network() {

	interface=$(ip route | grep '^default' | awk '{print $5}' | head -n1)

	if [ -z "$interface" ]; then
		printf "^c$white^ 󰈅 N/A"
		return
	fi

	rx_bytes=$(cat /sys/class/net/$interface/statistics/rx_bytes)
	tx_bytes=$(cat /sys/class/net/$interface/statistics/tx_bytes)

	if [ ! -f /tmp/net_rx_prev ]; then
		echo $rx_bytes > /tmp/net_rx_prev
		echo $tx_bytes > /tmp/net_tx_prev
		printf "^c$white^ 󰈅 --"
		return
	fi

	rx_prev=$(cat /tmp/net_rx_prev)
	tx_prev=$(cat /tmp/net_tx_prev)

	rx_rate=$(( (rx_bytes - rx_prev) ))
	tx_rate=$(( (tx_bytes - tx_prev) ))

	echo $rx_bytes > /tmp/net_rx_prev
	echo $tx_bytes > /tmp/net_tx_prev

	if [ $rx_rate -gt 1048576 ]; then
		rx_display=$(awk -v r=$rx_rate 'BEGIN {printf "%.1fM", r/1048576}')
	elif [ $rx_rate -gt 1024 ]; then
		rx_display=$(awk -v r=$rx_rate 'BEGIN {printf "%.0fK", r/1024}')
	else
		rx_display="${rx_rate}B"
	fi

	if [ $tx_rate -gt 1048576 ]; then
		tx_display=$(awk -v t=$tx_rate 'BEGIN {printf "%.1fM", t/1048576}')
	elif [ $tx_rate -gt 1024 ]; then
		tx_display=$(awk -v t=$tx_rate 'BEGIN {printf "%.0fK", t/1024}')
	else
		tx_display="${tx_rate}B"
	fi
	printf "^c$black^^b$darkblue^ Net "
	printf "^c$white^^b$grey^↓${rx_display}^c$white^^b$grey^↑${tx_display}"
}

clock() {
	# printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%a %b%_d %H:%M')"
}

while true; do
  sleep 1 && xsetroot -name "$(network) $(cpu) $(mem) $(clock)"
done
