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
```

## Configuration

Before running the script, the following variables need to be configured:
* **ALERT:** Disk usage percentage threshold (default is 80).
* **ADMIN:** The email address of the system administrator who will receive the alerts.
* **FROM:** The email address the alert emails will be sent from.
* **EXCLUDE_LIST:** A pipe-separated (|) list of partitions to exclude from monitoring (e.g., /auto/ripper|loop).
* **LOGFILE:** Path to the log file where all operations are logged (default is /var/log/diskSpaceWatcher.log).

## Usage

1. Clone this repository or copy the script to your server.
2. Set execute permissions on the script:
```bash
chmod +x diskAlert.sh
```
3. Edit the script to configure the ADMIN email and any other variables as needed.
4. Run the script manually:
```bash
./diskAlert.sh
```

## Scheduling with Cron
1
. To automate the disk space monitoring, you can schedule this script to run at regular intervals using cron jobs.
```bash
Open the crontab editor:
```
2. Add a cron job to run the script at your desired frequency. For example, to run it daily at 2 AM, add this line:
```bash
0 2 * * * /path/to/diskAlert.sh
```
3. The format of the cron job is:

```bash
minute hour day-of-month month day-of-week command
```

## Example Output
* Email Alert:
```html
Subject: WARNING - Disk space of your_server_name is running low

<html>
<body>
    <h3>Disk Space Alert on Server "your_server_name"</h3>
    <p><strong>Date:</strong> 2024-10-22 14:30:01</p>
    <ul>
        <li>Running out of space on partition "/dev/sda1 (85%)".</li>
        <li>Running out of space on partition "/boot (90%)".</li>
    </ul>
</body>
</html>
```

* Log File (/var/log/diskSpaceWatcher.log):

```bash
2024-10-22 14:30:01 - Disk space check started.
2024-10-22 14:30:02 - Running out of space on partition "/dev/sda1 (85%)".
2024-10-22 14:30:03 - At least one alert has been triggered, sending the email to admin@mail.com.
2024-10-22 14:30:03 - Email has been sent to admin@mail.com.
2024-10-22 14:30:04 - Disk space check completed.
```

## Notes
* Ensure that the system's sendmail is configured correctly to send emails. If you prefer to use another email-sending method (like ssmtp or mailx), modify the sendAlertEmail function in the script.
* Make sure the script has the appropriate permissions to write to /var/log/ or change the path of LOGFILE to a more suitable location.

## License
This script is released under the MIT License.
