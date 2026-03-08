# 🏭 Modded Satisfactory Auto-Sync

A fully automatic way to share one modded Satisfactory world with your friends. 
If someone is already playing, the system will lock the world and warn you!

---

## 🛠️ First-Time Setup (Takes 5 Minutes)

You only need to do this once! 

### 1. Install Required Software
You need to install two quick things so the background automation works:
1. **GitHub Desktop:** [Download Here](https://desktop.github.com/) (Sign in with your GitHub account).
2. **Git for Windows:** [Download Here](https://gitforwindows.org/) (Just click "Download", run the installer, and click "Next" on everything. You don't need to change any settings).

### 2. Get the World & Configure
1. Open **GitHub Desktop** and **Clone** this repository to your PC.
2. Open this downloaded folder on your computer.
3. Duplicate the file `config.template.ps1` and rename the copy to exactly **`config.ps1`**.
4. Open `config.ps1` and paste your SteamID and a PC Name. *(See below if you don't know your SteamID).*

### 3. Sync the Mods
1. Open your **Satisfactory Mod Manager (SMM)**.
2. Click the **Import** button (downward arrow) under the Profile section.
3. Select the `.smm` profile file located in this repository folder. 
4. The Mod Manager will automatically download the exact same mods the server uses!

**You are done! You never have to do these setup steps again.**

---

## 🎮 How to Play

Whenever you want to play, **do not** open GitHub Desktop or the Mod Manager directly. 

Instead, open this folder and double-click:
### 🚀 `Play_Modded.bat`

A black window will open. Here is what it does automatically:
1. **Checks the server:** If a friend is already playing (or forgot to sync), it screams 🛑 **STOP!** and tells you who has the lock. Contact them!
2. **Locks the world:** If it's free, it locks the server so nobody else can join.
3. **Downloads the save:** It grabs the newest world and puts it in your game folder.
4. **Opens the Mod Manager:** Click "Launch" inside SMM like normal. 
5. **Uploads when you quit:** When you close Satisfactory, the black window detects it, backs up your new save, uploads it, and unlocks the server for the next person!

⚠️ **CRITICAL RULE:** Never close the black sync window while playing, or your save won't upload!

---

## 🔍 How to find your Steam ID
1. Open Steam.
2. Go to your Profile page.
3. Look at the web link (URL) at the top. Copy the long 17-digit number at the end. *(Example: 76561198012345678)*