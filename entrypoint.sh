#!/bin/sh

run_rancid() {
    su - rancid -c "rancid-cvs && rancid-run
}

run_rancid

sleep 180

aws s3 cp /home/rancid/var/routers/configs/gw-1 s3://cisco--config-backups
aws s3 cp /home/rancid/var/routers/configs/gw-2 s3://cisco--config-backups
aws s3 cp /home/rancid/var/routers/configs/gw-3 s3://cisco--config-backups

tmpfile=$(mktemp)

crontab -l > "$tmpfile"

echo "0 0,12 *** rancid /usr/bin/rancid-run" >> "$tmpfile
echo "3 0,12 *** sleep 180 && aws s3 cp /home/rancid/var/routers/configs/gw-1 s3://cisco--config-backups"
echo "3 0,12 *** sleep 180 && aws s3 cp /home/rancid/var/routers/configs/gw-2 s3://cisco--config-backups"
echo "3 0,12 *** sleep 180 && aws s3 cp /home/rancid/var/routers/configs/gw-3 s3://cisco--config-backups"

crontab "$tmpfile"
rm "$tmpfile"
crond -f

tail -f /dev/null