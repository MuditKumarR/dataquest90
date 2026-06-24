# 🦫 Installing DBeaver

## What is DBeaver?

DBeaver is a universal database tool that supports PostgreSQL, MySQL, Snowflake, Oracle, SQLite, and 80+ other databases.

For this course, DBeaver is the **recommended tool** for intermediate and advanced learners because:
- Clean, distraction-free SQL editor
- Powerful ERD (Entity-Relationship Diagram) viewer
- Easy multi-database connection management
- Works identically on Windows, Mac, and Linux
- Free and open source (Community Edition)

---

## Download DBeaver

Go to: https://dbeaver.io/download/

Download **DBeaver Community** (free) for your operating system.

---

## Windows Installation

1. Run the downloaded `.exe` installer
2. Accept the license
3. Select **Install for all users** (recommended)
4. Choose installation directory (default is fine)
5. Select **Add DBeaver to PATH** (recommended)
6. Click **Install**
7. Launch DBeaver

---

## macOS Installation

1. Open the downloaded `.dmg`
2. Drag **DBeaver** to the Applications folder
3. Open from Applications

If macOS blocks it (Gatekeeper):
- Go to **System Settings** → **Privacy & Security**
- Click **Open Anyway** next to DBeaver

---

## Linux Installation

### Ubuntu/Debian (DEB package):
```bash
# Download the .deb file from https://dbeaver.io/download/
sudo dpkg -i dbeaver-ce_*.deb
sudo apt-get install -f  # Fix any dependency issues
```

### Or via Snap:
```bash
sudo snap install dbeaver-ce
```

### Or via Flatpak:
```bash
flatpak install flathub io.dbeaver.DBeaverCommunity
```

---

## First Launch

1. DBeaver opens and may ask about sample databases — click **No**
2. You will see the Database Navigator panel on the left

---

## Connect to PostgreSQL

### Step 1 — New Connection

Click the **New Connection** button (plug icon) in the toolbar.

Or: **Database** menu → **New Database Connection**

### Step 2 — Select Database Type

Select **PostgreSQL** and click **Next**.

### Step 3 — Connection Settings

| Field | Value |
|-------|-------|
| Host | `localhost` |
| Port | `5432` |
| Database | `dataverse` |
| Username | `postgres` |
| Password | `postgres` |

### Step 4 — Download Driver

If prompted, click **Download** to install the PostgreSQL JDBC driver.

### Step 5 — Test Connection

Click **Test Connection**. You should see: `Connected`

Click **Finish**.

---

## Running Queries

1. In the Database Navigator, expand your connection → **dataverse** → **Schemas** → **public** → **Tables**
2. Right-click any table → **View Data** to see the data
3. To write SQL: **SQL Editor** → **Open SQL Console** (or `Ctrl+Alt+Enter`)

---

## Key DBeaver Features for This Course

### ERD Diagram Viewer
1. Right-click the **dataverse** database
2. Select **View Diagram**
3. DBeaver draws all tables and their relationships

This is extremely useful for understanding the DataVerse schema.

### Query Execution Plan
1. Write a query in the SQL editor
2. Press `Ctrl+Shift+E` (or click Explain Execution Plan button)
3. DBeaver shows the visual execution plan

### Data Export
1. Run a query
2. In the Results panel, click **Export Results**
3. Choose CSV, Excel, JSON, or other formats

---

## Key DBeaver Shortcuts

| Shortcut | Action |
|----------|--------|
| Ctrl+Enter | Execute current query |
| Ctrl+Shift+E | Explain execution plan |
| Ctrl+Space | Auto-complete |
| Ctrl+/ | Comment/uncomment |
| Ctrl+Shift+F | Format SQL |
| Ctrl+D | Duplicate line |
| Alt+Up/Down | Move line up/down |
| Ctrl+F | Find in editor |

---

## DBeaver vs pgAdmin — Which Should You Use?

| Feature | DBeaver | pgAdmin |
|---------|---------|---------|
| SQL Editor | Excellent | Good |
| ERD Diagrams | Built-in | Plugin needed |
| Multiple DB support | 80+ databases | PostgreSQL only |
| Performance monitoring | Limited | Excellent |
| Beginner friendliness | Moderate | High |
| Multi-database connections | Excellent | Good |
| Recommended for | Analytics engineers | DBAs / beginners |

**Recommendation:** Use pgAdmin for learning basics, switch to DBeaver for serious development.

---

## Troubleshooting

### "Driver not found" error

Click **Download/Update** when prompted during connection setup.

### Connection timeout

Check PostgreSQL is running. On Windows: `net start postgresql-x64-17`

### Java errors on startup

DBeaver requires Java 17+. Download from: https://adoptium.net/

### High memory usage

DBeaver can use 500MB+ of RAM. Increase heap if needed:
- **Help** → **Edit Config** → Uncomment and increase `-Xmx` value

---

## Next Step

Load the DataVerse dataset: [07-loading-sample-data.md](07-loading-sample-data.md)
