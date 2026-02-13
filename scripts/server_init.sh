#!/bin/bash

echo "--- SERVER HEALTH & SECURITY CHECK ---"

# 1. Paket Güncellemelerini Kontrol Et
echo "[1/4] Checking for updates..."
sudo apt update -y

# 2. Firewall Durumu
echo "[2/4] Firewall Status:"
sudo ufw status | grep -i "Status"

# 3. Port Kontrolü (2222)
echo "[3/4] Checking Port 2222..."
(command -v netstat >/dev/null && netstat -tulpn | grep 2222) || ss -tulpn | grep 2222 || echo "WARNING: Port 2222 not found!"

# 4. Sistem Kaynakları ve Veri Toplama
echo "[4/4] System Summary:"
uptime
free -h

# --- VERİ İŞLEME ---
# Disk doluluk oranını alıyoruz
THRESHOLD=80
DISK_USAGE=$(df -h / | grep / | awk '{print $5}' | sed 's/%//' | head -n 1)
CURRENT_TIME=$(date "+%d.%m.%Y - %H:%M")

if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    echo "!!! ALERT: DISK SPACE IS LOW ($DISK_USAGE%) !!!"
else
    echo "Disk Usage: $DISK_USAGE% (Normal)"
fi

echo "--- CHECK COMPLETED ---"

# --- WEB DASHBOARD UPDATE ---
# Nginx'in okuduğu dosya yolu
WEB_FILE="/var/www/html/index.html"

# 1. Disk yüzdesini HTML içinde bul ve güncel (sed kullanarak)
# Bu regex: >% ile başlayıp < ile biten her şeyi yakalar ve güncel $DISK_USAGE ile değiştirir.
sudo sed -i "s/>%[0-9]*</>$DISK_USAGE%</g" $WEB_FILE

# 2. Son güncellenme zamanını HTML içinde bul ve güncel (sed kullanarak)
# Bu regex: 00.00.0000 - 00:00 formatını yakalar ve $CURRENT_TIME ile değiştirir.
sudo sed -i "s/[0-9]\{2\}\.[0-9]\{2\}\.[0-9]\{4\} - [0-9]\{2\}:[0-9]\{2\}/$CURRENT_TIME/g" $WEB_FILE

echo "[OK] Web Dashboard updated at $CURRENT_TIME"
