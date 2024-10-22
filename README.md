# Disk Space Monitoring Script

## Overview

This Bash script monitors the disk space usage on a server and sends email alerts to a specified administrator when disk usage exceeds a certain threshold. The script can exclude specific partitions from monitoring and logs the disk space check results into a log file for auditing purposes.

## Features

- **Threshold-based alerts**: Sends an email when any partition exceeds the defined disk usage threshold.
- **Customizable email content**: Sends detailed HTML email with the list of partitions running low on space.
- **Exclusion of partitions**: Allows excluding specific partitions from being monitored.
- **Logging**: Logs all actions, including triggered alerts, to `/var/log/diskSpaceWatcher.log`.

## Requirements

- **Bash**
- **df**: Disk free utility (pre-installed on most Linux systems)
- **sendmail**: For sending email alerts (can be replaced with other MTA if needed)
  
You can install `sendmail` using:

```bash
sudo apt-get install sendmail
