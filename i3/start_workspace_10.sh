#!/bin/bash

i3-msg "workspace 10: 󰧨"

sleep 1

i3-msg "append_layout $HOME/.config/i3/layouts/workspace-10.json"

ghostty --title=btop -e sh -c "clear && exec btop" &
sleep 0.3
ghostty --title=neofetch -e sh -c "neofetch; read -p 'Nice...'" &
sleep 0.3
ghostty --title=cmatrix -e $HOME/.config/i3/run_cmatrix.sh &
