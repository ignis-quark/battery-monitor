#!/bin/bash

#Place in /usr/local/bin/
#Service goes in /etc/systemd/system/
#Timer goes in /etc/systemd/system/

WARNING_LEVEL=10
CRITICAL_LEVEL=5

PERCENT=$(upower -b | grep percentage | awk '{print $2}' | tr -d "%")
STATE=$(upower -b | grep state | awk '{print $2}')

if [[ "$STATE" == "discharging" ]]; then
    if [ "$PERCENT" -le "$CRITICAL_LEVEL" ]; then
        logger "BATTERY LEVEL CRITICAL! ${PERCENT}%! SHUTTING DOWN SYSTEM!"
        #/usr/bin/systemctl poweroff
    elif [ "$PERCENT" -le "$WARNING_LEVEL" ]; then
        logger "Battery warning noted at ${PERCENT}%"
        
        USER=$(users | head -n 1)
        USER_ID=$(id -u "$USER")

        sudo -u "$USER" DISPLAY=:0 \
            DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$USER_ID"/bus \
            /usr/bin/notify-send -u critical "Battery Low!" "Battery level is at ${PERCENT}%."
    fi

fi