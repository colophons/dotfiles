#!/bin/sh
INTERFACE="eth0"
ip -o -4 a show dev "$INTERFACE" | awk '{print $4;}' | cut -d '/' -f 1
