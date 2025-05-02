#!/bin/bash
status=$(cat /sys/class/power_supply/BAT*/status)
percentage=$(cat /sys/class/power_supply/BAT*/capacity)

icon="<big><big></big></big>"
[[ "$status" == "Discharging" ]] && icon="<big><big></big></big>"

echo " $icon $percentage% "

