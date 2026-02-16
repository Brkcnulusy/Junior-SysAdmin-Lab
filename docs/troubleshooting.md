# Troubleshooting: SSH Host Key Verification Error

## Problem
When trying to connect to the server via SSH, I received the following security warning:
`WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!`
This happened because the server was reinstalled, and its unique fingerprint (identification) changed while the IP address remained the same.

## Analysis
My local machine (Windows) still had the old server's fingerprint stored in the `known_hosts` file. SSH blocked the connection to prevent a potential "Man-in-the-Middle" attack.

## Solution
To fix this, I had to remove the old, outdated key from my local machine using the following command in PowerShell:

```powershell
ssh-keygen -R 192.168.65.128

## Problem: SCP Connection Refused (2026-02-16)
When trying to transfer files via SCP from Windows, the connection was refused.

## Solution
Since SSH was moved to port 2222, default SCP (port 22) failed. Fixed by using `-P 2222` flag:
`scp -P 2222 local_file user@ip:/path/`
