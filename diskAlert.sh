#!/bin/bash

# Configurable variables
ALERT=80
ADMIN="admin@mail.com"
DATE=$(date "+%Y-%m-%d %H:%M:%S")
FROM="support@mail.com"
HOSTNAME="$(hostname)"
SUBJECT="WARNING - Disk space of $HOSTNAME is running low"
LOGFILE="/var/log/diskSpaceWatcher.log"

# Exclude list of unwanted monitoring, if several partitions, then use "|" to separate the partitions.
EXCLUDE_LIST="/auto/ripper|loop"

# Check if the necessary tools are installed
check_requirements() {
    if ! command -v sendmail &> /dev/null; then
        echo "Error: sendmail is not installed. Exiting."
        exit 1
    fi

    if ! command -v df &> /dev/null; then
        echo "Error: df command not found. Exiting."
        exit 1
    fi
}

# Ensure log file exists
ensure_logfile() {
    if [ ! -f "$LOGFILE" ]; then
        touch "$LOGFILE"
        if [ $? -ne 0 ]; then
            echo "Error: Cannot create log file at $LOGFILE. Exiting."
            exit 1
        fi
    fi
}

# Log messages to log file and console
log_message() {
    local message="$1"
    echo "$DATE - $message" | tee -a "$LOGFILE"
}

# Send email alert
sendAlertEmail() {
    local body="$1"
    (
        echo "From: ${FROM}"
        echo "To: ${ADMIN}"
        echo "Subject: ${SUBJECT}"
        echo "Content-Type: text/html"
        echo "MIME-Version: 1.0"
        echo ""
        echo "$body"
    ) | sendmail -t

    log_message "Email has been sent to $ADMIN."
}

# Main disk space checking function
main_prog() {
    local body="<html><body><h3>Disk Space Alert on Server \"${HOSTNAME}\"</h3><p><strong>Date:</strong> $DATE</p><ul>"
    local sendEmail=false

    while read -r output; do
        usep=$(echo "$output" | awk '{print $1}' | cut -d'%' -f1)
        partition=$(echo "$output" | awk '{print $2}')
        if [ "$usep" -ge "$ALERT" ]; then
            msg="Running out of space on partition \"$partition ($usep%)\"."
            log_message "$msg"
            body="${body}<li>${msg}</li>"
            sendEmail=true
        fi
    done

    body="${body}</ul></body></html>"

    if $sendEmail ; then
        log_message "At least one alert has been triggered, sending an email to $ADMIN."
        sendAlertEmail "$body"
    else
        log_message "No alert triggered, exiting the program."
    fi
}

# Main script execution
main() {
    check_requirements
    ensure_logfile

    log_message "Disk space check started."

    if [ "$EXCLUDE_LIST" != "" ]; then
        df -H | grep -vE "^Filesystem|tmpfs|cdrom|${EXCLUDE_LIST}" | awk '{print $5 " " $6}' | main_prog
    else
        df -H | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{print $5 " " $6}' | main_prog
    fi

    log_message "Disk space check completed."
}

# Run the main function
main
