# Server Initialization & Health Check Script

## Purpose
This script is designed to run every time I log into the server to ensure the system is up-to-date, secure, and healthy.

## Script Contents (`scripts/server_init.sh`)
The script automates the following tasks:
- **System Updates:** Runs `apt update` to check for new packages.
- **Firewall Check:** Verifies if UFW is active.
- **Port Monitoring:** Confirms SSH is listening on port 2222.
- **Resources:** Displays disk usage, RAM, and uptime.

## How to Run
1. Upload/Create the file on the server.
2. Grant execution rights: `chmod +x server_init.sh`
3. Execute: `./server_init.sh`