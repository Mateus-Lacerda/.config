#!/bin/bash

i3-msg "workspace 10"

i3-msg [workspace=4] kill

sleep 1

i3-msg "append_layout $HOME/.config/i3/layouts/workspace-10.json"

kitty --title btop -e sh -c "clear && exec btop" &
sleep 0.3
kitty --title cmatrix -e sh -c "clear && exec cmatrix" &
sleep 0.3
kitty -T "neofetch" -e sh -c "neofetch; read -p 'Nice...'" &
