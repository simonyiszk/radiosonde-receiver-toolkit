#!/bin/bash

waiting=1
telemetry_ok=0

echo "Follow the notifications for further information"
termux-notification -i "sonde_loc" --priority max -t "Waiting for radiosonde location..." -c "Swipe to quit" --on-delete "killall rs41mod" # Exit when notification is swiped

while [ $waiting -eq 1 ]
do

read var # Read from pipe

if [[ $var == *"lat: "* ]] && [[ $var == *" lon: "* ]] && [[ $var == *" alt"* ]] && [[ $var == *" vH"* ]] ; then # Check if coordinates present in packet
    telemetry_ok=1
else
    telemetry_ok=0
    echo "Incomplete telemetry: $var"
fi

# Extract latitude
tmp=${var#*lat: } # Remove prefix starting with "lat:"
lat=${tmp%  lon*} # Remove suffix starting with "lon:"

# Extract longitude
tmp=${var#*lon: } # Remove prefix starting with "lon:"
lon=${tmp%  alt*} # Remove suffix starting with "alt:"

# Extract altitude
tmp=${var#*alt: } # Remove prefix starting with "alt:"
alt=${tmp%  vH*} # Remove suffix starting with "vH:"

if [[ -z "$lat" ]] || [[ -z "$lon" ]] || [[ -z "$alt" ]]; then # If no input given (broken pipe)
    echo "Quitting..."
    sleep 1
    waiting=0
fi

if [[ $telemetry_ok -eq 1 ]]; then
    echo "Location found: $lat, $lon, $alt"
    # Open location in default app on tap
    termux-notification -i "sonde_loc" -t "Radiosonde location found: $lat, $lon, $alt" -c "Tap to show on map!" --action "am start -a android.intent.action.VIEW -d 'geo:$lat,$lon?z=18&q=$lat,$lon' &>/dev/null" --on-delete "killall rs41mod"
fi

done
