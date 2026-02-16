#!/bin/bash

# Renkler / Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

WEB_FILE="/home/burak/Junior-SysAdmin-Lab/index.html"

# Zaman bilgisi / Time Info
TIME=$(date "+%d.%m.%Y - %H:%M")

echo -e "${BLUE}--- [1/5] UPGRADE & SOURCE PREP ---${NC}"
echo -e "${YELLOW}TR: Sistem paketleri güncelleniyor ve HTML kaynak kodu işleniyor...${NC}"
echo -e "${YELLOW}EN: Updating system packages and processing HTML source code...${NC}"
sudo apt update -y && sudo apt upgrade -y > /dev/null 2>&1
# HTML içeriğini güvenli hale getir (kaynak monitörü için)
HTML_CONTENT=$(cat "$WEB_FILE" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
echo -e "${GREEN}>>> TAMAMLANDI / COMPLETED${NC}\n"

echo -e "${BLUE}--- [2/5] DATA COLLECTION ---${NC}"
echo -e "${YELLOW}TR: CPU, RAM ve Disk metrikleri sistemden toplanıyor...${NC}"
echo -e "${YELLOW}EN: Collecting CPU, RAM, and Disk metrics from the system...${NC}"
# Kararlı CPU LOAD çekme yöntemi
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d',' -f1)
DISK_TOTAL=$(df -BG / | grep / | awk '{print $2}' | sed 's/G//')
DISK_USED=$(df -BG / | grep / | awk '{print $3}' | sed 's/G//')
DISK_PCT=$(df / | grep / | awk '{print $5}' | sed 's/%//' | head -n 1)
RAM_TOTAL_MB=$(free -m | grep Mem | awk '{print $2}')
RAM_USED_MB=$(free -m | grep Mem | awk '{print $3}')
RAM_PCT=$(( 100 * RAM_USED_MB / RAM_TOTAL_MB ))
RAM_TOTAL_GB=$(echo "scale=1; $RAM_TOTAL_MB/1024" | bc | awk '{printf "%.1f", $0}')
RAM_USED_GB=$(echo "scale=1; $RAM_USED_MB/1024" | bc | awk '{printf "%.1f", $0}')
UPTIME_SHORT=$(uptime -p | sed 's/up //')
UPTIME_RAW=$(uptime -s)
UPDATES=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
echo -e "${GREEN}>>> TAMAMLANDI / COMPLETED${NC}\n"

echo -e "${BLUE}--- [3/5] SERVICE AUDIT ---${NC}"
echo -e "${YELLOW}TR: Kritik servislerin (Nginx, SSH, UFW) durumları kontrol ediliyor...${NC}"
echo -e "${YELLOW}EN: Checking status of critical services (Nginx, SSH, UFW)...${NC}"
NGINX=$(systemctl is-active nginx | tr '[:lower:]' '[:upper:]')
SSH=$(ss -tulpn | grep -q ":2222" && echo "OPEN" || echo "CLOSED")
UFW=$(sudo ufw status | grep -q "active" && echo "ACTIVE" || echo "INACTIVE")
echo -e "${GREEN}>>> TAMAMLANDI / COMPLETED${NC}\n"

echo -e "${BLUE}--- [4/5] DASHBOARD SYNC ---${NC}"
echo -e "${YELLOW}TR: Toplanan metrikler HTML şablonuna enjekte ediliyor...${NC}"
echo -e "${YELLOW}EN: Injecting collected metrics into the HTML template...${NC}"
# Veri Enjeksiyonu / Data Injection
sed -i "s/id=\"uptime-raw\"[^>]*>[^<]*/id=\"uptime-raw\" style=\"color:var(--accent)\">$UPTIME_RAW/g" $WEB_FILE
sed -i "s/id=\"uptime-val\"[^>]*>[^<]*/id=\"uptime-val\">$UPTIME_SHORT/g" $WEB_FILE
sed -i "s/id=\"cpu-val\"[^>]*>[^<]*/id=\"cpu-val\" style=\"color:var(--success)\">%$CPU_LOAD/g" $WEB_FILE
sed -i "s/id=\"disk-pct\"[^>]*>[^<]*/id=\"disk-pct\">$DISK_PCT%/g" $WEB_FILE
sed -i "s/id=\"disk-bar\"[^>]*style=\"[^\"]*\"/id=\"disk-bar\" class=\"progress-fill\" style=\"width: $DISK_PCT%;\"/g" $WEB_FILE
sed -i "s/id=\"disk-info\"[^>]*>[^<]*/id=\"disk-info\">$DISK_USED GB \/ $DISK_TOTAL GB/g" $WEB_FILE
sed -i "s/id=\"ram-pct\"[^>]*>[^<]*/id=\"ram-pct\">$RAM_PCT%/g" $WEB_FILE
sed -i "s/id=\"ram-bar\"[^>]*style=\"[^\"]*\"/id=\"ram-bar\" class=\"progress-fill\" style=\"background:#a855f7; width: $RAM_PCT%;\"/g" $WEB_FILE
sed -i "s/id=\"ram-info\"[^>]*>[^<]*/id=\"ram-info\">$RAM_USED_GB GB \/ $RAM_TOTAL_GB GB/g" $WEB_FILE
sed -i "s/id=\"stat-nginx\"[^>]*>[^<]*/id=\"stat-nginx\" style=\"color:var(--success)\">$NGINX/g" $WEB_FILE
sed -i "s/id=\"stat-ssh\"[^>]*>[^<]*/id=\"stat-ssh\" style=\"color:var(--success)\">$SSH/g" $WEB_FILE
sed -i "s/id=\"stat-fw\"[^>]*>[^<]*/id=\"stat-fw\" style=\"color:var(--success)\">$UFW/g" $WEB_FILE
sed -i "s/id=\"last-apt-check\"[^>]*>[^<]*/id=\"last-apt-check\" style=\"color:var(--accent)\">$TIME/g" $WEB_FILE
sed -i "s/id=\"last-update\"[^>]*>[^<]*/id=\"last-update\">$TIME/g" $WEB_FILE
sed -i "s/id=\"pending-up\"[^>]*>[^<]*/id=\"pending-up\" style=\"color:var(--warn)\">$UPDATES/g" $WEB_FILE

# Kaynak kod kutusunu güncelle / Update source monitor
perl -i -0777 -pe "s|<div class=\"code-window\" id=\"full-source\">.*?</div>|<div class=\"code-window\" id=\"full-source\">$HTML_CONTENT</div>|s" $WEB_FILE

echo -e "${GREEN}>>> DASHBOARD GÜNCELLENDİ / DASHBOARD UPDATED${NC}\n"

echo -e "${BLUE}--- [5/5] FINISHED ---${NC}"
echo -e "${GREEN}TR: Tüm işlemler başarıyla tamamlandı.${NC}"
echo -e "${GREEN}EN: All operations completed successfully.${NC}"
