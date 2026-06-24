# 🐳 PostgreSQL Docker Setup

## Why Docker?

Docker is the **fastest way** to get PostgreSQL running without worrying about installation, system configuration, or port conflicts.

With Docker you can:
- Start PostgreSQL in 30 seconds
- Destroy and rebuild your database with a single command
- Run multiple PostgreSQL versions simultaneously
- Keep your system clean

This is the **recommended setup** for this course.

---

## Prerequisites

### Install Docker

**Windows / Mac:** Download Docker Desktop from https://www.docker.com/products/docker-desktop/

**Linux (Ubuntu):**
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
```

Verify Docker is installed:
```bash
docker --version
# Docker version 27.x.x
```

---

## Start PostgreSQL with Docker

### One-Command Setup

```bash
docker run --name postgres-learning \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_DB=dataverse \
  -p 5432:5432 \
  -d postgres:17
```

**That's it.** PostgreSQL 17 is now running with:
- Database: `dataverse`
- User: `postgres`
- Password: `postgres`
- Port: `5432`

---

## Verify It's Running

```bash
docker ps
```

You should see:
```
CONTAINER ID   IMAGE        COMMAND                  STATUS         PORTS
a1b2c3d4e5f6   postgres:17  "docker-entrypoint.s…"  Up 5 seconds   0.0.0.0:5432->5432/tcp
```

---

## Connect to PostgreSQL

### Via Docker exec (command line):

```bash
docker exec -it postgres-learning psql -U postgres -d dataverse
```

You should see:
```
psql (17.x)
Type "help" for help.

dataverse=#
```

### Via any SQL client (pgAdmin, DBeaver):

Connection settings:
| Field | Value |
|-------|-------|
| Host | `localhost` |
| Port | `5432` |
| Database | `dataverse` |
| Username | `postgres` |
| Password | `postgres` |

---

## Docker Management Commands

```bash
# Start the container (if stopped)
docker start postgres-learning

# Stop the container
docker stop postgres-learning

# Restart the container
docker restart postgres-learning

# Remove the container (DELETES ALL DATA)
docker rm -f postgres-learning

# View container logs
docker logs postgres-learning

# Follow logs in real-time
docker logs -f postgres-learning

# Get a bash shell inside the container
docker exec -it postgres-learning bash

# Check PostgreSQL version
docker exec postgres-learning psql -U postgres -c "SELECT version();"
```

---

## Persistent Data with Volume Mount

By default, if you delete the container, all data is lost.

To keep data between container restarts and deletions:

```bash
docker run --name postgres-learning \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_DB=dataverse \
  -p 5432:5432 \
  -v postgres-data:/var/lib/postgresql/data \
  -d postgres:17
```

The `-v postgres-data:/var/lib/postgresql/data` flag creates a named Docker volume.

---

## Docker Compose Setup (Advanced)

Create a file named `docker-compose.yml`:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:17
    container_name: postgres-learning
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: dataverse
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./DATASETS:/docker-entrypoint-initdb.d
    restart: unless-stopped

volumes:
  postgres-data:
```

Start with:
```bash
docker compose up -d
```

Stop with:
```bash
docker compose down
```

> **Tip:** The `./DATASETS:/docker-entrypoint-initdb.d` mount automatically runs all `.sql` files in the DATASETS folder when the container first starts.

---

## Load the DataVerse Dataset via Docker

```bash
# Copy the dataset file into the container
docker cp DATASETS/00-load-all.sql postgres-learning:/tmp/

# Run it
docker exec -it postgres-learning psql -U postgres -d dataverse -f /tmp/00-load-all.sql
```

---

## Windows-Specific Notes

### Docker Desktop must be running

Check the Docker Desktop icon in the system tray. If not running, open Docker Desktop first.

### WSL2 Backend

Docker Desktop on Windows uses WSL2 (Windows Subsystem for Linux). If Docker Desktop asks to install WSL2 update, accept it.

### Port conflicts

If port 5432 is in use by a local PostgreSQL installation:

```bash
docker run --name postgres-learning \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_DB=dataverse \
  -p 5433:5432 \
  -d postgres:17
```

Then connect on port `5433`.

---

## Troubleshooting

### "Cannot connect to the Docker daemon"

Docker is not running. Open Docker Desktop or:
```bash
sudo systemctl start docker  # Linux only
```

### "port is already allocated"

Another service is using port 5432. Either stop it or use a different port (see Windows notes above).

### "no space left on device"

Clear unused Docker resources:
```bash
docker system prune -a
```

---

## Next Step

Load the DataVerse Inc. dataset: [07-loading-sample-data.md](07-loading-sample-data.md)
