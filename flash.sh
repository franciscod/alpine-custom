#!/usr/bin/env bash
set -e

if [ "$(id -u)" != "0" ]; then
    echo you should be root
    exit 1
fi

IMG=drive.img

if [ ! -e "$IMG" ]; then
    echo "the img doesn't exist?"
    exit 1
fi

echo ok, plug a flash drive

SD=$(head -n 1 \
        <(dmesg -W | \
          grep --line-buffered 'sd.*Attached.*removable') \
        | awk -F'[][]' '{print $4}')

echo will write to "$SD" in 3 seconds...
sleep 3

ddrescue -D --force "$IMG" "/dev/$SD"
