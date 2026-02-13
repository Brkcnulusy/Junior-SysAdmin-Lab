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
# netstat yüklü değilse ss kullanılır
(command -v netstat >/dev/null && netstat -tulpn | grep 2222) || ss -tulpn | grep 2222 || echo "WARNING: Port 2222 not found!"

# 4. Sistem Kaynakları ve Akıllı Uyarı
echo "[4/4] System Summary:"
uptime
free -h

# Disk Doluluk Kontrolü (Eşik Değeri: %80)
THRESHOLD=80
DISK_USAGE=$(df -h / | grep / | awk '{print $5}' | sed 's/%//' | head -n 1)

if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
    echo "!!! ALERT: DISK SPACE IS LOW ($DISK_USAGE%) !!!"
else
    echo "Disk Usage: $DISK_USAGE% (Normal)"
fi

echo "--- CHECK COMPLETED ---"