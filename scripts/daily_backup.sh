#!/bin/bash

# Değişkenler
SOURCE="/home/burak/Junior-SysAdmin-Lab"
DEST="/home/burak/backups/project_backups"
DATE=$(date +%F_%H-%M)
FILENAME="backup_$DATE.tar.gz"

echo "--- BACKUP STARTED [$DATE] ---"

# Yedekleme klasörü yoksa oluştur
mkdir -p $DEST

# Sıkıştır ve yedekle (Bu sefer 'v' kullanmıyoruz, loglar temiz kalsın)
tar -czf $DEST/$FILENAME $SOURCE

echo "SUCCESS: Project backed up to $DEST/$FILENAME"
echo "--- BACKUP COMPLETED ---"
