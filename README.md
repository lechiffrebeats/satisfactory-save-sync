# 🏭 Modded Satisfactory Auto-Sync

A fully  automatic way to share one modded Satisfactory world with your friends. 
No dedicated server needed! The system handles all the downloading, uploading, cloud backups, and mod syncing for you.

---

## ⚠️ THE GOLDEN RULE
**Only ONE person can play at a time!** Our system checks if the server is free. If someone else is playing, it will stop and warn you. Do not bypass the lock, or you will split the timeline and ruin the save!

---

## 🛠️ First-Time Setup (Takes 5 Minutes)

You only need to do this once!

### 1. Install Required Software
1. **GitHub Desktop:** [Download Here](https://desktop.github.com/). Sign in and clone this repository.
2. **Git for Windows:** [Download Here](https://gitforwindows.org/). Run the installer and click "Next" on everything. (This makes the background script work!).

### 2. Configure Your Profile
1. Open this repository folder on your computer.
2. Duplicate the file `config.template.ps1` and rename the copy to exactly **`config.ps1`**.
3. Open `config.ps1` and paste your SteamID and a PC Name. *(To find your SteamID, go to your Steam Profile in a browser and copy the 17-digit number at the end of the URL).*

### 3. Sync the Mods
1. Open your **Satisfactory Mod Manager (SMM)**.
2. Click the **Import** button (downward arrow icon).
3. Select the `modpack.smmprofile` file located in this folder. 
4. SMM will automatically download all the correct mods!

---

## 🎮 How to Play

Whenever you want to play, **do not** open GitHub Desktop, SMM, or Steam directly. 

Instead, open this folder and double-click your preferred version:
* 🚀 **`Play_Vanilla.bat`** (If you want to play without mods).
* 🚀 **`Play_Modded.bat`** (If you are playing with the group's modpack).

A black window will open. Here is what happens automatically:
* **Checks & Locks:** It checks if a friend is playing. If it's free, it locks the world for you.
* **Downloads:** It grabs the newest save file and puts it in your game folder.
* **Launches:** It opens SMM or Steam automatically. 
* **Uploads:** When you close Satisfactory, WAIT FOR A FEW SECONDS! the black window detects it, backs up your new save, uploads it to the cloud, and unlocks the server!

⚠️ **CRITICAL:** Never close the black sync window while playing, or your save won't upload!

---

## 📦 How to Add New Mods

Want to add a new mod to the server? It's completely automatic!

1. Open SMM and install your new mods.
2. Click the **Export** button in SMM.
3. Save the file as exactly `modpack.smmprofile` and overwrite the old one in this repository folder.
4. Double-click `Play_Modded.bat` to play the game normally. 
5. When you quit, the script will automatically upload the new `modpack.smmprofile` to GitHub. The next friend to play will get a 🚨 **RED WARNING** 🚨 telling them to import your new changes!

---

## 🌍 Want to use this for your own friend group?

Do not clone this repository directly, or you won't have permission to upload your saves! Instead, you need to create your own private copy. 

**Only ONE person (the Group Host) needs to do this:**

### 1. Create your own Cloud Server
1. Scroll to the top of this GitHub page and click the green **Use this template** button.
2. Click **Create a new repository**.
3. Give it a name (e.g., `Jonas-Satisfactory-Server`).
4. Set it to **Private** (so only your friends can see it).
5. Click **Create repository**. 

### 2. Invite your friends
You now have your own private cloud server! But your friends need permission to access it.
1. On your new repository page, click **Settings** ⚙️.
2. Click **Collaborators** on the left menu.
3. Click **Add people** and invite your friends using their GitHub usernames.

### 3. Start Playing!
Now, you and your friends just open **GitHub Desktop**, click **File → Clone Repository**, and select YOUR new private repository from the list. Follow the setup instructions above, and you are good to go!