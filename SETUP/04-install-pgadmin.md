# 🖥️ Installing pgAdmin 4

## What is pgAdmin?

pgAdmin is the official GUI management tool for PostgreSQL. It lets you:
- Browse databases, tables, and views
- Run SQL queries with syntax highlighting
- Monitor server performance
- Manage users and permissions
- View query execution plans visually

For beginners, pgAdmin is the easiest way to work with PostgreSQL.

---

## Download pgAdmin 4

Go to: https://www.pgadmin.org/download/

Select your operating system:
- Windows: Download the `.exe` installer
- macOS: Download the `.dmg` file
- Linux: Use the APT or YUM repository

---

## Windows Installation

1. Run the downloaded `.exe` as Administrator
2. Accept the license agreement
3. Choose installation directory (default is fine)
4. Click **Next** → **Install**
5. Wait for installation to complete
6. Click **Finish**

pgAdmin 4 opens in your default web browser.

---

## macOS Installation

1. Open the `.dmg` file
2. Drag **pgAdmin 4** to your Applications folder
3. Open pgAdmin 4 from Applications
4. macOS may ask for permission — click **Open**

pgAdmin 4 opens in your default web browser.

---

## Linux Installation (Ubuntu/Debian)

```bash
# Install the repository key
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

# Add the repository
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] \
  https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) \
  pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

sudo apt update

# Desktop mode (recommended for learning)
sudo apt install pgadmin4-desktop

# Web mode (for server deployments)
sudo apt install pgadmin4-web
```

---

## First Launch — Set Master Password

When pgAdmin opens for the first time, it will ask for a **Master Password**.

This password encrypts stored server connection passwords.

**For this learning environment, use:**
```
Master Password: pgadmin
```

> Do not lose this. If you forget it, you'll need to reset all saved passwords.

---

## Connect to Your PostgreSQL Server

### Step 1

In pgAdmin, click **Add New Server** (or right-click on Servers → Register → Server).

### Step 2 — General Tab

- **Name:** `DataVerse Learning`

### Step 3 — Connection Tab

| Field | Value |
|-------|-------|
| Host | `localhost` |
| Port | `5432` |
| Maintenance database | `postgres` |
| Username | `postgres` |
| Password | `postgres` |

Check **Save password**.

### Step 4

Click **Save**.

You should now see **DataVerse Learning** in the server list.

---

## Connect to the DataVerse Database

1. Expand **DataVerse Learning** → **Databases**
2. Click on **dataverse**
3. You will see the database schema

---

## Running Your First Query

1. Click on the **dataverse** database
2. Click **Tools** → **Query Tool** (or press `Alt+Shift+Q`)
3. Type your query:

```sql
SELECT current_database(), current_user, version();
```

4. Press **F5** or click the **Execute** button (▶)

You should see results in the Data Output panel.

---

## Key pgAdmin Shortcuts

| Shortcut | Action |
|----------|--------|
| F5 | Execute query |
| Ctrl+Space | Auto-complete |
| Ctrl+/ | Comment/uncomment selected lines |
| F7 | Explain (execution plan) |
| Shift+F7 | Explain Analyze |
| Ctrl+Shift+U | Uppercase selection |
| Ctrl+L | Clear query editor |

---

## Viewing the Execution Plan

1. Write a query in the Query Tool
2. Click **Explain** (or press F7) instead of Execute
3. Switch to the **Explain** tab to see the visual execution plan

This is essential for Mission 09 (Performance Tuning).

---

## Troubleshooting

### pgAdmin doesn't connect to server

- Ensure PostgreSQL is running (check Services on Windows, `systemctl status postgresql` on Linux)
- Verify host: `localhost`, port: `5432`
- Verify username: `postgres`, password: `postgres`

### "SSL connection" errors

In the Connection tab, set **SSL mode** to `prefer` or `disable`.

### pgAdmin loads but shows blank page

Clear your browser cache, or try opening pgAdmin in a private/incognito window.

### Forgot Master Password

Delete the pgAdmin config folder:
- Windows: `%APPDATA%\pgAdmin`
- Mac: `~/Library/Preferences/pgAdmin 4`
- Linux: `~/.local/share/pgAdmin4`

---

## Alternative: Use DBeaver

If pgAdmin feels overwhelming, DBeaver is a great alternative.

→ [05-install-dbeaver.md](05-install-dbeaver.md)
