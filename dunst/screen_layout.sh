#!/bin/bash

ACTION=$(dunstify \
  -a "Layout de tela pessoal." \
  " Deseja usar seu monitor pessoal?" \
  --action="default,Rodar" \
  --action="cancel,Cancelar")

case "$ACTION" in
  "default")
    bash ~/.screenlayout/mancer_monitor_home.sh
    ;;
  "cancel"|"2")
    ;;
  *)
    ;;
esac

