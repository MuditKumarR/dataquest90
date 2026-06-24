# 🐧 Installing PostgreSQL on Linux (Ubuntu / Debian)

## Overview

This guide covers installing PostgreSQL 17 on Ubuntu 22.04 / 24.04 or Debian 12.

**Time required:** ~10 minutes

---

## Method 1 — Official PostgreSQL APT Repository (Recommended)

### Step 1 — Add the PostgreSQL APT Repository

```bash
sudo apt install -y curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc \
  --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] \
  https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" \
  > /etc/apt/sources.list.d/pgdg.list'
```

### Step 2 — Install PostgreSQL 17

```bash
sudo apt update
sudo apt install -y postgresql-17
```

### Step 3 — Start and Enable PostgreSQL

```bash
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### Step 4 — Verify

```bash
sudo systemctl status postgresql
```

You should see: `Active: active (running)`

### Step 5 — Connect

```bash
sudo -u postgres psql
```

You should see:
```
psql (17.x)
Type "help" for help.

postgres=#
```

### Step 6 — Set Password

```sql
ALTER USER postgres WITH PASSWORD 'postgres';
```

Type `\q` to exit.

---

## Method 2 — Ubuntu Default Repository

For a simpler but potentially older version:

```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib
```

---

## Configure Remote Access (Optional)

By default PostgreSQL only accepts local connections.

### Allow local password authentication:

Edit `/etc/postgresql/17/main/pg_hba.conf`:

```bash
sudo nano /etc/postgresql/17/main/pg_hba.conf
```

Find the line:
```
local   all   postgres   peer
```

Change it to:
```
local   all   postgres   md5
```

Restart PostgreSQL:
```bash
sudo systemctl restart postgresql
```

Now you can connect with:
```bash
psql -U postgres -h localhost
```

---

## Create the DataVerse Database

```bash
sudo -u postgres psql
```

```sql
CREATE DATABASE dataverse;
\c dataverse
```

---

## Useful PostgreSQL Commands on Linux

```bash
# Start PostgreSQL
sudo systemctl start postgresql

# Stop PostgreSQL
sudo systemctl stop postgresql

# Restart PostgreSQL
sudo systemctl restart postgresql

# Check status
sudo systemctl status postgresql

# View logs
sudo tail -f /var/log/postgresql/postgresql-17-main.log

# Access PostgreSQL config
sudo nano /etc/postgresql/17/main/postgresql.conf

# Access client authentication config
sudo nano /etc/postgresql/17/main/pg_hba.conf
```

---

## Troubleshooting

### "psql: error: connection to server on socket failed"

```bash
sudo systemctl start postgresql
```

### "role postgres does not exist"

```bash
sudo -u postgres createuser --superuser postgres
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"
```

### "FATAL: peer authentication failed for user postgres"

Edit `pg_hba.conf` and change authentication method from `peer` to `md5` (see above).

### PostgreSQL not starting after system update

```bash
sudo pg_ctlcluster 17 main start
```

---

## FAQ

**Q: Which Linux distributions are supported?**  
A: Ubuntu 20.04+, Debian 10+, CentOS/RHEL 8+, Fedora 35+

**Q: How do I run PostgreSQL on CentOS/RHEL?**  
A: Use the PostgreSQL Yum repository: https://yum.postgresql.org/

```bash
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo dnf install -y postgresql17-server
sudo /usr/pgsql-17/bin/postgresql-17-setup initdb
sudo systemctl enable postgresql-17
sudo systemctl start postgresql-17
```

**Q: How do I allow connections from other machines?**  
A: Edit `postgresql.conf`: set `listen_addresses = '*'`  
Then add a rule in `pg_hba.conf` for the remote IP.  
Ensure firewall allows port 5432.

---

## Next Step

Install pgAdmin: [04-install-pgadmin.md](04-install-pgadmin.md)

Or load the DataVerse dataset: [07-loading-sample-data.md](07-loading-sample-data.md)
