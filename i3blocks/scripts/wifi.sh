#!/bin/bash

get_wifi_status() {
    # Pega a interface conectada via Wi-Fi
    interface=$(nmcli -t -f DEVICE,TYPE con show --active | grep "wireless" | cut -d: -f1)
    essid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
    quality=$(nmcli -f IN-USE,SIGNAL dev wifi | grep '*' | awk '{print $2}')

    if [[ -n "$interface" && -n "$essid" ]]; then
      echo " 󱚻 ${quality}% "
    else
      echo " 󱚻 down "
    fi
}

handle_click() {
  case "$1" in
    1) nm-connection-editor;;
  esac
}

# Main logic
if [[ -n "$BLOCK_BUTTON" ]]; then
  handle_click "$BLOCK_BUTTON"
fi

get_wifi_status
