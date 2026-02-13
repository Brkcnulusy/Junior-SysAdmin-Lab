# Task 01: SSH Hardening & Troubleshooting
**Date:** 2026-02-13
**Status:** Completed

## Objective
To secure the server by changing the default SSH port and resolving configuration persistence issues on Ubuntu 24.04.

## Actions Taken
1. **Port Change:** Modified `/etc/ssh/sshd_config` to set `Port 2222`.
2. **Package Management:** Installed `net-tools` to use `netstat` for verification.
3. **Socket Activation Fix:** Discovered that modern Ubuntu uses `ssh.socket`. Resolved by:
   - `sudo systemctl daemon-reload`
   - `sudo systemctl restart ssh.socket`
4. **Firewall Configuration:** Allowed the new port using `sudo ufw allow 2222/tcp`.

## Verification
- Verified listening port using `ss -tulpn | grep 2222`.
- Successfully connected from host machine via `ssh -p 2222 burak@192.168.65.128`.