#!/bin/bash

# 1. AYAR DOSYASINI YÜKLE (Configuration Sourcing)
# Scriptin ayarları dışarıdaki bir dosyadan okumasını sağlar.
CONF_FILE="/home/burak/Junior-SysAdmin-Lab/config/backup_settings.conf"

if [ -f "$CONF_FILE" ]; then
    source "$CONF_FILE"
else
    echo "ERROR: Configuration file not found at $CONF_FILE"
    exit 1
fi

# 2. DEĞİŞKENLER (Variables)
DATE=$(date +%F_%H-%M)
FILENAME="backup_$DATE.tar.gz"

echo "--- BACKUP OPERASYONU BAŞLADI [$DATE] ---"

# 3. HAZIRLIK (Preparation)
# Yedekleme klasörü yoksa oluşturur (Ayar dosyasından gelen BACKUP_DEST kullanılır)
if [ ! -d "$BACKUP_DEST" ]; then
    echo "Creating backup directory: $BACKUP_DEST"
    mkdir -p "$BACKUP_DEST"
fi

# 4. SIKIŞTIRMA VE ARŞİVLEME (Compression)
# tar komutu ile projeyi paketle
tar -czf "$BACKUP_DEST/$FILENAME" "$SOURCE_DIR"

# 5. DOĞRULAMA VE TEMİZLİK (Verification & Cleanup)
if [ $? -eq 0 ]; then
    echo "SUCCESS: Proje başarıyla yedeklendi -> $BACKUP_DEST/$FILENAME"
    
    # Opsiyonel: RETENTION_DAYS'den eski yedekleri otomatik siler
    # Ayar dosyasındaki gün sayısına göre eski yedekleri temizler (SysAdmin dokunuşu!)
    find "$BACKUP_DEST" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete
    echo "CLEANUP: $RETENTION_DAYS günden eski yedekler temizlendi."
else
    echo "ERROR: Yedekleme sırasında bir hata oluştu!"
    exit 1
fi

/bin/bash /home/burak/Junior-SysAdmin-Lab/scripts/server_init.sh

echo "--- BACKUP OPERASYONU TAMAMLANDI ---"
