# Satisfactory Save Sync (GitHub Desktop)

Simple version control for our shared **Satisfactory** save file so we can all play the same world.

We use **GitHub + GitHub Desktop** to upload and download the newest `.sav` file.

This guide is for people who **do not know Git**.

---

# One-Time Setup

1. Install **GitHub Desktop**
2. Clone this repository
3. Open the repository folder on your PC

---

# Before You Start Playing

⚠️ Always download the newest save first.

1. Open **GitHub Desktop**
2. Click **Fetch origin**
3. Click **Pull**

Now you have the newest save.

Copy the newest `.sav` file into your Satisfactory save folder:

```

C:\Users<yourname>\AppData\Local\FactoryGame\Saved\SaveGames<your-steam-id>\

```

Then start **Satisfactory** and play.

---

# After You Finished Playing

1. Copy the newest `.sav` file from your Satisfactory save folder back into the **repository folder**

2. Open **GitHub Desktop**

3. Write a commit message like:

```

Played 08.03 – built steel factory

```

4. Click:

```

Commit to main
Push origin

```

Now the new save is uploaded and the next player can download it.

---

# Important Rule

⚠️ Only **one person plays at a time**.

Always do this:

Before playing:
```

Fetch → Pull

```

After playing:
```

Commit → Push

```

Otherwise someone might overwrite another player's progress.

---

# Repository Structure

```

repo/
│
├─ saves/
│   └─ world.sav
│
└─ README.md

```

---

# Recommended

Enable **Auto Save / Backup** in Satisfactory so we always have backups.
