#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please specify frequency in MHz as an argument when executing this program!'
    exit 1
fi

if (systemctl is-active --quiet gpsd) || (systemctl is-active --quiet gpsd.socket) ; then
    echo -e "gpsd service is running! Please stop via 'sudo systemctl stop gpsd' and 'sudo systemctl stop gpsd.socket' commands!"
    exit 1
fi

if [ ! -p /tmp/gpsfake-sonde.sock ]; then
    echo "Creating socket... you may have to perform 'sudo gpsdctl add /tmp/gpsfake-sonde.sock' manually."
    mkfifo /tmp/gpsfake-sonde.sock
fi

process=$(pgrep gpsd)
if [[ ! -z "$process" ]] ; then
    kill $process
fi

nohup gpsd -n -N /tmp/gpsfake-sonde.sock &> /dev/null &

rtl_sdr -f "$1"M -s 250k - | ./rs41mod -v --IQ 0.0 - 250000 8 | ./pos2nmea.pl > /tmp/gpsfake-sonde.sock
