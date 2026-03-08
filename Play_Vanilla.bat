@echo off
color 07
title Vanilla Satisfactory Sync + Auto-Update

echo 🔍 Checking for logic updates from lechiffrebeats...
git remote add template https://github.com/lechiffrebeats/satisfactory-save-sync.git 2>nul
git fetch template --quiet
git merge template/main --allow-unrelated-histories --quiet
echo ✅ Logic is up to date.
echo.

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0system\sync_logic.ps1' -Mode Vanilla"