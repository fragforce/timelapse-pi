#!/usr/bin/env bash
STORE="/media/pi/LAPSE"
RES="1280x720"
DATE=$(date +"%Y-%m-%d_%H%M")
CAMERA="C270"
C_FILE="/home/pi/scripts/usbreset.c"
C_URL="https://gist.githubusercontent.com/x2q/5124616/raw/bf21dbda4a67de2c2d15d6c66b1e1bd0b1db7e1b/usbreset.c"
RESET=/home/pi/scripts/usbreset

function build_reset {
  if [ ! -f ${C_FILE} ]; then
    echo "C file missing"
    wget -O ${C_FILE} ${C_URL}
  fi
  cc ${C_FILE} -o ${RESET}
}
function reset_camera {
  if [ ! -f ${RESET} ]; then
    build_reset
  fi
  BUS=`lsusb | grep ${CAMERA} | cut -c5-7`
  DEVICE=`lsusb | grep "$CAMERA" | cut -c16-18`
  sleep 1
  sudo /home/pi/scripts/usbreset /dev/bus/usb/${BUS}/${DEVICE}
  sleep 5
}
if [ ! -d ${STORE} ]; then
  echo "No storage device found"
  exit 1
fi
reset_camera
fswebcam -r ${RES} --quiet --no-banner --png 0 ${STORE}/${DATE}.png
