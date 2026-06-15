Runs a systemd service every 5 minutes (using a systemd timer) to check battery life.
Gives a warning at 10%, and shuts down the system at 5% (if discharging)

Warnings and critical battery shutdown are logged to the journal using logger.

Run the batmon_install.sh to easily install.

batmon_install.sh will do the following:
#Place battery_monitor.sh in /usr/local/bin/
#Place battery-monitor.service in /etc/systemd/system/
#Place battery-monitor.timer in /etc/systemd/system/
#Execute systemctl daemon-reload
#Execute systemctl enable battery-monitor.timer
