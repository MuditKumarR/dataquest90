# 🍎 Installing PostgreSQL on macOS

## Overview

This guide covers installing PostgreSQL 17 on macOS using **Homebrew** (recommended) or the **Postgres.app** installer.

**Time required:** ~10 minutes

---

## Method 1 — Homebrew (Recommended)

### Step 1 — Install Homebrew (if not installed)

Open **Terminal** and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Verify:
```bash
brew --version
```

### Step 2 — Install PostgreSQL

```bash
brew install postgresql@17
```

This downloads and installs PostgreSQL 17.

### Step 3 — Start PostgreSQL

```bash
brew services start postgresql@17
```

To start automatically at login:
```bash
brew services start postgresql@17
```

### Step 4 — Add to PATH

Add to your `~/.zshrc` (or `~/.bash_profile` for older Macs):

```bash
echo 'export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Step 5 — Verify

```bash
psql --version
# postgresql 17.x
```

### Step 6 — Connect

```bash
psql postgres
```

You should see:
```
psql (17.x)
Type "help" for help.

postgres=#
```

### Step 7 — Set Password

```sql
ALTER USER postgres WITH PASSWORD 'postgres';
```

Type `\q` to exit.

---

## Method 2 — Postgres.app

### Step 1 — Download

Go to: https://postgresapp.com/

Download **Postgres.app** (latest version with PostgreSQL 17).

### Step 2 — Install

1. Drag **Postgres.app** to your Applications folder
2. Open it
3. Click **Initialize** to create a new PostgreSQL server

### Step 3 — Add CLI Tools

Click **Open psql** in Postgres.app, or add to PATH:

```bash
sudo mkdir -p /etc/paths.d
echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
```

Restart Terminal.

### Step 4 — Verify

```bash
psql --version
```

---

## Create the DataVerse Database

```bash
psql postgres
```

```sql
CREATE USER postgres WITH PASSWORD 'postgres' SUPERUSER;
CREATE DATABASE dataverse OWNER postgres;
\c dataverse
```

---

## Troubleshooting

### "command not found: psql"

PATH is not set correctly. Rerun the PATH export command and `source ~/.zshrc`.

### "could not connect to server"

PostgreSQL is not running.

```bash
brew services restart postgresql@17
```

Or via Postgres.app: click the elephant icon and click **Start**.

### Permission denied errors

```bash
sudo chown -R $(whoami) /opt/homebrew/var/postgresql@17
brew services restart postgresql@17
```

### Port 5432 already in use

```bash
lsof -i :5432
```

Kill the existing process or stop other database services.

---

## FAQ

**Q: Homebrew or Postgres.app — which is better?**  
A: Homebrew is better for developers who use the terminal. Postgres.app is easier if you prefer GUIs.

**Q: How do I stop PostgreSQL?**  
A: `brew services stop postgresql@17`

**Q: How do I upgrade PostgreSQL?**  
A: `brew upgrade postgresql@17` (backup your data first)

---

## Next Step

Install pgAdmin: [04-install-pgadmin.md](04-install-pgadmin.md)

Or load the DataVerse dataset: [07-loading-sample-data.md](07-loading-sample-data.md)
