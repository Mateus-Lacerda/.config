#!/bin/bash
usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
printf "<span foreground='#b16286'></span><span background='#b16286' foreground='#000000'> CPU  %.0f%% | $(sensors | grep 'Package id 0:' | awk '{print $4}')</span><span foreground='#282828' background='#b16286'></span>\n" "$usage"

