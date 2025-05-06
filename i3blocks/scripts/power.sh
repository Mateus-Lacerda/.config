#!/bin/bash

show_icon() {
    echo "  "
}

handle_click() {
  case "$1" in
    1) $HOME/.config/scripts/power;;
  esac
}

if [[ -n "$BLOCK_BUTTON" ]]; then
  handle_click "$BLOCK_BUTTON"
fi

show_icon
