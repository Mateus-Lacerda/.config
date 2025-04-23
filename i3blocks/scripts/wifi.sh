#!/bin/bash

# Pega a interface conectada via Wi-Fi
interface=$(nmcli -t -f DEVICE,TYPE con show --active | grep "wireless" | cut -d: -f1)
essid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
quality=$(nmcli -f IN-USE,SIGNAL dev wifi | grep '*' | awk '{print $2}')

if [[ -n "$interface" && -n "$essid" ]]; then
  echo "<span foreground='#d3869b'></span><span background='#d3869b' foreground='#000000'>󱚻 ${quality}% | ${essid} </span><span foreground='#282828' background='#d3869b'></span>"
else
  echo "<span foreground='#d3869b'></span><span background='#d3869b' foreground='#000000'>󱚻 down </span><span foreground='#282828' background='#d3869b'></span>"
fi

