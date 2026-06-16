
TEMP=$(getopt -o hu --long help,upgrade )

while true; do
    case "$1" in
        -h | --help )
            echo "Installs the script, service, and timer files, then activates the service."
            echo "Usage: batmon_install.sh [OPTION]"
            echo "  -u      Upgrade only: Replace the .sh file in case you decided to change the script and don't want to mess with the system service files."
            exit
            ;;
        -u | --upgrade )
            UPGRADEONLY=true
            shift
            ;;
            
            -- ) shift; break;;
            * ) break ;;
    esac
done

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This is a system service. Run as Root."
    exit
fi

echo Installing battery monitor...

SH_PATH=/usr/local/bin/
SYS_PATH=/etc/systemd/system/

cp -v battery_monitor.sh "$SH_PATH"
if ! [[ $UPGRADEONLY ]]; then
    cp -v battery-monitor.service "$SYS_PATH"
    cp -v battery-monitor.timer "$SYS_PATH"
else
    echo -u flag specified. Only upgraded shell script...
fi
echo "Files installed."

if ! [[ $UPGRADEONLY ]]; then
    systemctl daemon-reload
    echo Reloaded systemctl daemon
    systemctl enable --now battery-monitor.timer
    echo Enabled battery-monitor.timer
fi
echo Complete!