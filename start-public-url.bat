@echo off
echo ==========================================================
echo  CampusHire - Starting Public Tunnel
echo ==========================================================

echo Starting Cloudflare Tunnel on port 8080...
"%~dp0cloudflared.exe" tunnel --url http://localhost:8080

pause
