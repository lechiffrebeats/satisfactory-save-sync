@echo off
color 07
title Satisfactory Server Sync
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0sync_logic.ps1'"
pause