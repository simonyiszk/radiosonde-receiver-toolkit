#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please specify frequency in MHz as an argument when executing this program!'
    exit 1
fi

rtl_sdr -f "$1"M -s 250k - | ./rs41mod -v --IQ 0.0 - 250000 8
