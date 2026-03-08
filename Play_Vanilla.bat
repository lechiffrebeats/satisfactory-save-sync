@echo off
color 07
title Vanilla Satisfactory Sync
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0system\sync_logic.ps1' -Mode Vanilla"