#!/bin/bash

get_bluetooth_status() {
    # Verifica o status do Bluetooth
    bluetooth_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
    bluetooth_device=$(bluetoothctl info | grep "Name:" | awk '{$1=""; print $0}' | sed 's/^ *//')

    if [[ "$bluetooth_status" == "yes" && -n "$bluetooth_device" ]]; then
        echo " <big>󰂯</big> ${bluetooth_device} "
    elif [[ "$bluetooth_status" == "yes" ]]; then
        echo " <big>󰂯</big> on "
    else
        echo " <big>󰂲</big> off "
    fi
}

handle_click() {
    case "$1" in
        1) blueman-manager &;;
    esac
}

# Main logic
if [[ -n "$BLOCK_BUTTON" ]]; then
    handle_click "$BLOCK_BUTTON"
else
    get_bluetooth_status
fi
