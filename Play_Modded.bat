@echo off
color 07
title Modded Satisfactory Sync
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0system\sync_logic.ps1'"