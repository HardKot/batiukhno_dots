#!/usr/bin/env bash

receive_pip="/tmp/hypridle-ddc-module-rx"

brightness=50


if brightness=$(ddcutil -t getvcp 10); then
  brightness=$(echo "$brightness" | cut -d ' ' -f 4)  
    ddcutil -t setvcp 10 15
  fi


rm -rf $receive_pip
mkfifo $receive_pip

while true; do
  read -r command < $receive_pip
  case $command in 
    1)
      ddcutil -t setvcp 10 "${brightness}"
      break
      ;;
  esac
done
