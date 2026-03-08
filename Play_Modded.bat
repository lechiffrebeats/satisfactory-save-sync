@echo off
color 07
title Modded Satisfactory Sync + Auto-Update

:: --- AUTO-UPDATE LOGIC ---
echo 🔍 Checking for logic updates from lechiffrebeats...
:: Add your repo as a remote if it doesn't exist
git remote add template https://github.com/lechiffrebeats/satisfactory-save-sync.git 2>nul
:: Fetch and merge changes quietly
git fetch template --quiet
git merge template/main --allow-unrelated-histories --quiet
echo ✅ Logic is up to date.
echo.

:: --- START GAME SYNC ---
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0system\sync_logic.ps1' -Mode Modded"