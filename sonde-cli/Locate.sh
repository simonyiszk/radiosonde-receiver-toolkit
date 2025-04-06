
if [[ $# -eq 0 ]] ; then
    dialog=$(termux-dialog -t "Please specify frequency in MHz:")
    freq=$(echo $dialog | grep -o '"text": "[^"]*' | grep -o '[^"]*' | tail -1) # Read input from dialog if no argument present
else
    freq=$1
fi

echo -e "\n\n\n\nStarting rtl_tcp..."
am start-activity "iqsrc://-a 127.0.0.1 -p 1234" &>/dev/null # Launch Rtl-sdr driver
sleep 3
echo "Waiting for radiosonde signals..."

freq_val=$(awk '{ printf("%08X",$1*1000000) }' <<< $freq) # Convert MHz to Hz and change to big endian hex bytes
set_freq="\x01\x${freq_val:0:2}\x${freq_val:2:2}\x${freq_val:4:2}\x${freq_val:6:2}" # Build rtl-tcp frequency set command

set_gain_mode="\x03\x00\x00\x00\x00" # Set automatic gain
set_agc_mode="\x08\x00\x00\x00\x01" # Enable agc

samp_rate=250000 # Sample rate
samp_rate_val=$(awk '{ printf("%08X",$1) }' <<< $samp_rate) # Convert to big endian hex bytes
set_sample_rate="\x02\x${samp_rate_val:0:2}\x${samp_rate_val:2:2}\x${samp_rate_val:4:2}\x${samp_rate_val:6:2}" # Build rtl-tcp sample rate set command

echo "(Tuning to $freq MHz)"

# Set rtl-tcp parameters, read IQ stream, run demodulation and pass to map updater
echo -e "${set_sample_rate}${set_gain_mode}${set_agc_mode}${set_freq}" | nc 127.0.0.1 1234 | ${BASH_SOURCE%/*}/rs41mod -v --IQ 0.0 - $samp_rate 8 | bash ${BASH_SOURCE%/*}/view_on_map.sh

echo "The end"
sleep 1
