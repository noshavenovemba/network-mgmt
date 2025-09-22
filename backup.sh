#!/bin/sh
TIMESTAMP=$(date +%Y%m%d%H%M)
tar czf /tmp/rancid_backup_$TIMESTAMP.tar.gz /var/lib/rancid

aws s3 cp /tmp/rancid_backup_$TIMESTAMP.tar.gz s3://your-bucket-name/rancid-backups/
