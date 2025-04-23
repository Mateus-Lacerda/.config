#!/bin/bash
avail=$(df -h / | awk 'NR==2 {print $4}')
echo "<span foreground='#83a598'></span><span background='#83a598' foreground='#000000'> $avail </span><span foreground='#282828' background='#83a598'></span>"

