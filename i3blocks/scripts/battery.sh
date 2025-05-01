#!/bin/bash
status=$(cat /sys/class/power_supply/BAT*/status)
percentage=$(cat /sys/class/power_supply/BAT*/capacity)

icon=""
[[ "$status" == "Discharging" ]] && icon=""

echo " $icon $percentage% "

