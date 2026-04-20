# n8n Local Stack with Docker Compose

Self-hosted [n8n](https://n8n.io) running locally via Docker Compose, backed by PostgreSQL and Redis. Includes a worker node so workflows execute in queue mode — the same architecture you'd use in production.

**Based on original work by [Juan Bernardo Quintero](https://github.com/juanbdo).**

## Stack

| Service | Image | Purpose |
|---|---|---|
| `n8n` | `n8nio/n8n:latest` | Main editor + API |
| `n8n-worker` | `n8nio/n8n:latest` | Workflow executor (queue mode) |
| `n8n-postgres` | `postgres:16` | Persistent workflow/credential storage |
| `n8n-redis` | `redis:7-alpine` | Queue broker between main and worker |

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (or Docker Engine + Compose plugin)

## Setup

**1. Clone and enter the project directory**

```bash
git clone <repo-url>
cd n8n
```

**2. Create the environment file**

```bash
cp .env.example .env
```

Then open `.env` and change at minimum:

```bash
N8N_ENCRYPTION_KEY=replace-this-with-a-random-string
```

All other defaults work out of the box for `localhost`.

**3. Start the stack**

```bash
docker compose up
```

Add `-d` to run in the background:

```bash
docker compose up -d
```

**4. Open n8n**

Navigate to [http://localhost](http://localhost) and create your owner account on first run.

## Stopping

```bash
docker compose down
```

To also remove all data volumes (full reset):

```bash
docker compose down -v
```

## Configuration reference

| Variable | Default | Description |
|---|---|---|
| `POSTGRES_USER` | `postgres` | Postgres superuser |
| `POSTGRES_PASSWORD` | `postgres` | Postgres superuser password |
| `POSTGRES_DB` | `n8n` | Database name |
| `POSTGRES_NON_ROOT_USER` | `n8n_user` | Least-privilege user n8n connects as |
| `POSTGRES_NON_ROOT_PASSWORD` | `n8n_pass` | Password for the above |
| `N8N_ENCRYPTION_KEY` | *(change this)* | AES key for encrypting credentials at rest |
| `N8N_EDITOR_BASE_URL` | `http://localhost` | Public URL of the editor |
| `N8N_WEBHOOK_URL` | `http://localhost` | Base URL for webhook triggers |
| `GENERIC_TIMEZONE` | `America/Bogota` | Timezone for cron schedules |

## Notes

- Workflow data, credentials, and execution history are stored in the `n8n-postgres-data` Docker volume and survive container restarts.
- The `n8n-data` volume holds user-uploaded files and SSH keys referenced in workflows.
- This setup is intended for **local development**. Before exposing it externally, set `N8N_SECURE_COOKIE=true`, use a strong `N8N_ENCRYPTION_KEY`, and put n8n behind a reverse proxy with TLS.
