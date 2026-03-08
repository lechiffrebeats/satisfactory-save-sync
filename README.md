# 🏭 Modded Satisfactory Auto-Sync

A fully automatic way to share one modded Satisfactory world with your friends. 
If someone is already playing, the system will lock the world and warn you!

---

## 🛠️ First-Time Setup (Takes 2 Minutes)

1. **Install GitHub Desktop:** [Download here](https://desktop.github.com/). Sign in and clone this repository.
2. **Find your Steam ID:** Open your Steam Profile in a browser. Copy the 17-digit number at the end of the URL.
3. **Configure:** * Open this folder. 
   * Duplicate the file `config.template.ps1` and rename it to `config.ps1`.
   * Open `config.ps1` and paste your SteamID and a PC Name.

**You are done! You never have to do these steps again.**

---

## 🎮 How to Play

Whenever you want to play, **do not** open GitHub Desktop or the Mod Manager directly. 

Instead, double-click:
### 🚀 `Play_Modded.bat`

A black window will open. Here is what it does automatically:
1. **Checks the server:** If a friend is already playing (or forgot to sync), it screams 🛑 **STOP!** and tells you who has the lock. Contact them or just join via Steam!
2. **Locks the world:** If it's free, it locks the server so nobody else can join.
3. **Downloads the save:** It grabs the newest world and puts it in your game folder.
4. **Opens the Mod Manager:** Click "Launch" inside SMM like normal. 
5. **Uploads when you quit:** When you close Satisfactory, the black window detects it, backs up your new save, uploads it, and unlocks the server for the next person!

⚠️ **CRITICAL RULE:** Never close the black sync window while playing, or your save won't upload & do not manually pull or push or fetch or anything!