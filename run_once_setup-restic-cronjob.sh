#!/bin/sh

(crontab -l 2>/dev/null; echo "30 * * * * perl /home/herwig/.local/bin/restic_backup.pl >> /home/herwig/.local/share/logs/restic_backup.log 2>&1") | crontab -
echo "Add XDG_CONFIG_HOME and RESTIC_PASSWORD to crontab."
