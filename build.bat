@echo off
echo ==========================================================
echo  College Placement System (CampusHire) - Build & Deploy
echo ==========================================================

powershell.exe -ExecutionPolicy Bypass -File "%~dp0build.ps1"

pause
