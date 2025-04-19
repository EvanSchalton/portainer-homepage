# Portainer Homepage

This project creates a lightweight navigation homepage for Docker containers managed via Portainer.

It is designed for self-hosted environments where administrators want a simple way to list and link to internal services (e.g., Portainer, Neo4J, Grafana) without managing a full dashboard UI.

The homepage is served via NGINX and built from a configurable list of services defined via environment variables.

---

## Features

- Lightweight (based on `nginx:alpine`)
- Fully self-contained (no external assets)
- Configurable via `SERVICES` environment variable
- Designed for deployment via Portainer stacks
- Generates `index.html` at runtime using a shell script and HTML template

---

## Structure

```
app/
├── Dockerfile          # Builds the image from nginx and setup script
├── setup.sh            # Converts SERVICES to JSON and injects it into template
├── template.html       # Template with JS to render the service list
├── nginx.conf          # (Optional) Custom nginx config
```

---

## Deployment (via Portainer)

You can deploy this as a Git-backed stack inside Portainer.

### 1. Clone this repo

Or point Portainer directly to the Git repo URL.

### 2. Example `docker-compose.yml`:

```yaml
version: '3.8'

services:
  homepage:
    image: ghcr.io/yourname/portainer-homepage:latest
    ports:
      - "80:80"
    environment:
      SERVICES: |
        - Portainer: https://docker.lan:9443
        - Neo4J: http://docker.lan:7474/browser/
        - Grafana: http://docker.lan:3000
```

To add or remove services, update the `SERVICES` environment variable directly in the Portainer UI or stack definition.

---

## How It Works

1. `setup.sh` runs when the container starts.
2. It converts the YAML-style `SERVICES` variable into JSON.
3. It injects that JSON into `template.html`, replacing `{{SERVICES_JSON}}`.
4. The rendered file is saved as `index.html` and served by NGINX.

---

