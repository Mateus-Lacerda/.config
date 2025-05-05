#!/bin/bash

# Function to get volume and mute status
get_volume_status() {
  muted=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')
  volume=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | awk -F '/' '{print $2}' | head -n1 | tr -d ' ')

  # Check if pactl commands succeeded
  if [[ -z "$muted" || -z "$volume" ]]; then
    echo " Error "
    exit 1
  fi

  # Display volume or muted status with styles
  if [[ "$muted" == "yes" ]]; then
    echo " <big><big></big></big> Muted "
  else
    echo " <big><big></big></big> $volume "
  fi
}

# Handle click events
handle_click() {
  case "$1" in
    1) pavucontrol & ;; # Left click: open pavucontrol
    3) pactl set-sink-mute @DEFAULT_SINK@ toggle && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga ;; # Middle click: toggle mute
    4) pactl set-sink-volume @DEFAULT_SINK@ +5% && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga ;; # Scroll up: increase volume
    5) pactl set-sink-volume @DEFAULT_SINK@ -5% && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga ;; # Scroll down: decrease volume
  esac
}

# Main logic
if [[ -n "$BLOCK_BUTTON" ]]; then
  handle_click "$BLOCK_BUTTON"
fi

get_volume_status
