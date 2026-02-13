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
netstat -tulpn | grep 2222 || echo "WARNING: Port 2222 not found!"

# 4. Sistem Kaynakları
echo "[4/4] System Summary:"
uptime
df -h / | grep /
free -h

echo "--- CHECK COMPLETED ---"