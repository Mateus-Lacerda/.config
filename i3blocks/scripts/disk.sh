#!/bin/bash
avail=$(df -h / | awk 'NR==2 {print $4}')
echo " <big><big></big></big> $avail "

