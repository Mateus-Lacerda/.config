#!/bin/bash
status=$(cat /sys/class/power_supply/BAT*/status)
percentage=$(cat /sys/class/power_supply/BAT*/capacity)

icon=""
[[ "$status" == "Discharging" ]] && icon=""

echo "<span foreground='#458588'></span><span foreground='#000000' background='#458588'> $icon $percentage% </span><span foreground='#282828' background='#458588'></span>"

