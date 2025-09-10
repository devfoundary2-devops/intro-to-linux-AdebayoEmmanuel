#!/bin/bash

# This script needs root access to work.
if [ "$(id -u)" -ne 0 ]; then
    echo "Root access is required. Re-running with sudo."
    sudo "$0"
    exit
fi

# This is the full path to this script.
SCRIPT_PATH=$(realpath "$0")
LOG_FILE="/var/log/sysmon.log"
CRON_JOB="*/5 * * * * $SCRIPT_PATH"

# This command adds the cron job if it's not already there.
(crontab -l 2>/dev/null | grep -F -q "$CRON_JOB") || \
( (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab - && echo "Cron job installed." )

# --- Log System Metrics ---
echo "--- $(date) ---" >> "$LOG_FILE"

echo "CPU:" >> "$LOG_FILE"
uptime >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "MEMORY:" >> "$LOG_FILE"
free >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "DISK:" >> "$LOG_FILE"
df / >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "NETWORK:" >> "$LOG_FILE"
ip addr >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "--------------------" >> "$LOG_FILE"

echo "System metrics logged to $LOG_FILE"
