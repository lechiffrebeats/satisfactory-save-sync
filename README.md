# Satisfactory Save Sync

Too broke for server cost like us? -> Simple way to **share one Satisfactory world between multiple PCs** using **GitHub Desktop**.

No Git knowledge required.  
Just **Pull before playing** and **Push after playing**.

The repo automatically **copies saves to the correct game folder** and creates **timestamped backups with PC names**.

---

# Requirements

- Satisfactory
- GitHub account
- GitHub Desktop

---

# Setup (2 minutes)

### 1. Install GitHub Desktop

Download and install:

https://desktop.github.com

---

### 2. Clone this repository

Open **GitHub Desktop**

```

File → Clone Repository → URL

```

Clone the repo to your PC.

---

### 3. Configure once

Open:

```

config.ps1

````

Enter your information:

```powershell
$SteamID="YOUR_STEAM_ID"
$PCNAME="YOUR_PC_NAME"
````

Example:

```powershell
$SteamID="76561198012345678"
$PCNAME="DAVE"
```

---

### 4. Install automation

Run once:

```
install.ps1
```

This installs the automatic sync scripts.

Done.

---

# Playing Workflow

### Before playing

Open **GitHub Desktop**

```
Fetch origin
Pull
```

The newest save is automatically copied into your Satisfactory save folder.

Start the game and play.

---

### After playing

Open **GitHub Desktop**

```
Commit to main
Push origin
```

Your newest save is automatically uploaded.

---

# Important Rule

⚠️ **Only one person should play at a time**

Always:

```
Pull before playing
Push after playing
```

---

# Save File History

Every time someone pulls a save, a **timestamped backup** is created automatically.

Example:

```
world_RAMON-PC_2026-03-08_19-22-01.sav
world_TOBI-PC_2026-03-09_00-05-44.sav
world_JONAS-PC_2026-03-09_03-11-20.sav
```

This makes it easy to see **who played last** and prevents losing progress.

---

# Finding your SteamID

1. Open Steam
2. Go to your Profile
3. Copy the number from the URL

Example:

```
76561198012345678
```

---

# Repository Structure

```
repo/
│
├─ save/
│   └─ world.sav
│
├─ config.ps1
├─ install.ps1
└─ hooks/
```

---

# License

MIT

```
