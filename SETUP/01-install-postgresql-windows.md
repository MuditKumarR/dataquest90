# 🪟 Installing PostgreSQL on Windows

## Overview

This guide walks you through installing PostgreSQL 17 on Windows 10 or Windows 11.

**Time required:** ~15 minutes

---

## Prerequisites

- Windows 10 (64-bit) or Windows 11
- Administrator access
- At least 1 GB free disk space

---

## Step 1 — Download the Installer

1. Go to: https://www.postgresql.org/download/windows/
2. Click **Download the installer** (from EDB)
3. Select **Version 17.x** and **Windows x86-64**
4. Click **Download**

> The installer filename will look like: `postgresql-17.x-windows-x64.exe`

---

## Step 2 — Run the Installer

1. **Right-click** the downloaded `.exe` file
2. Select **Run as administrator**
3. Click **Next** on the Welcome screen

---

## Step 3 — Choose Installation Directory

- Default: `C:\Program Files\PostgreSQL\17`
- Accept the default unless you have a reason to change it
- Click **Next**

---

## Step 4 — Select Components

Check all of these:
- ✅ PostgreSQL Server
- ✅ pgAdmin 4
- ✅ Stack Builder
- ✅ Command Line Tools

Click **Next**

---

## Step 5 — Choose Data Directory

- Default: `C:\Program Files\PostgreSQL\17\data`
- Accept the default
- Click **Next**

---

## Step 6 — Set the Password

> ⚠️ **IMPORTANT:** Remember this password. You will need it to connect.

For this learning environment, use:
```
Password: postgres
```

Click **Next**

---

## Step 7 — Set the Port

- Default port: **5432**
- Do NOT change this
- Click **Next**

---

## Step 8 — Locale

- Accept the default locale
- Click **Next**

---

## Step 9 — Ready to Install

- Review the settings summary
- Click **Next** to begin installation

Installation takes 2–5 minutes.

---

## Step 10 — Complete

- Uncheck **Stack Builder** (not needed now)
- Click **Finish**

---

## Step 11 — Verify the Installation

Open **Command Prompt** as Administrator:

```cmd
psql -U postgres -h localhost
```

Enter your password when prompted. You should see:

```
psql (17.x)
Type "help" for help.

postgres=#
```

Type `\q` to exit.

---

## Step 12 — Add PostgreSQL to PATH (Optional)

If `psql` is not recognized:

1. Press `Win + S` → Search **Environment Variables**
2. Click **Edit the system environment variables**
3. Click **Environment Variables**
4. Under **System variables**, find **Path** → Click **Edit**
5. Click **New** and add:
   ```
   C:\Program Files\PostgreSQL\17\bin
   ```
6. Click **OK** three times
7. Restart Command Prompt

---

## Step 13 — Create the DataVerse Database

```cmd
psql -U postgres -h localhost
```

```sql
CREATE DATABASE dataverse;
\c dataverse
```

---

## Troubleshooting

### "psql is not recognized as an internal or external command"

PostgreSQL is not in your PATH. Follow Step 12 above.

### "connection refused" error

The PostgreSQL service may not be running.

1. Press `Win + R` → type `services.msc` → Enter
2. Find **postgresql-x64-17**
3. Right-click → **Start**

### "password authentication failed"

You entered the wrong password. Try resetting:

1. Open pgAdmin 4
2. Right-click on the server → Properties
3. Update the password

### Port 5432 already in use

Another service is using port 5432 (often another database).

```cmd
netstat -ano | findstr :5432
```

Find the PID and check what process it is in Task Manager.

---

## FAQ

**Q: Can I install multiple PostgreSQL versions?**  
A: Yes. Each version installs separately with different ports.

**Q: Do I need pgAdmin?**  
A: No, but it makes learning easier. DBeaver is also a great option.

**Q: How do I uninstall PostgreSQL?**  
A: Control Panel → Programs → Uninstall a program → PostgreSQL 17

---

## Next Step

Install pgAdmin: [04-install-pgadmin.md](04-install-pgadmin.md)

Or load the DataVerse dataset: [07-loading-sample-data.md](07-loading-sample-data.md)
