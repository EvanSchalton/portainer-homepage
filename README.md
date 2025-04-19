# Portainer Homepage

This project creates a lightweight navigation homepage for Docker containers managed via Portainer.

It is designed for self-hosted environments where administrators want a simple way to list and link to internal services (e.g., Portainer, Neo4J, Grafana) without managing a full dashboard UI.

The homepage is served via NGINX and built from a configurable list of services defined via environment variables.

---

## Features

- Lightweight (based on `nginx:alpine`)
- Fully self-contained (no external assets)
- Configurable via key-value environment variables in the Portainer UI
- Designed for deployment via Portainer stacks
- Generates `index.html` at runtime using a shell script and HTML template

---

## Structure

```
app/
├── Dockerfile          # Builds the image from nginx and setup script
├── setup.sh            # Converts environment variables to JSON and injects into template
├── template.html       # Template with JS to render the service list
├── nginx.conf          # (Optional) Custom nginx config
```

---

## Deployment (via Portainer)

You can deploy this as a Git-backed stack inside Portainer.

### 1. Clone this repo

Or point Portainer directly to the Git repo URL:

```
https://github.com/EvanSchalton/portainer-homepage.git
```

In the Portainer UI:
- Go to **Stacks** > **Add Stack**
- Choose **Git Repository**
- Paste the Git repo URL above
- Set the working directory to `/app` (if needed)

### 2. Example `docker-compose.yml`:

```yaml
version: '3.8'

services:
  homepage:
    image: ghcr.io/evanschalton/portainer-homepage:latest
    ports:
      - "80:80"
    environment: {}
```

Define services using key-value environment variables in the Portainer UI using the following naming pattern:

- `service_<id>_label`: The display name of the service
- `service_<id>_url`: The link for the service

Example:

| Key                    | Value                                  |
|------------------------|----------------------------------------|
| `service_portainer_label` | `Portainer`                        |
| `service_portainer_url`   | `https://docker.lan:9443`          |
| `service_neo4j_label`     | `Neo4J`                            |
| `service_neo4j_url`       | `http://docker.lan:7474/browser/`  |

Services are sorted by `<id>` (e.g., `portainer`, `neo4j`) for display order.

---

## Continuous Deployment

This project uses GitHub Actions to automatically build and push the Docker image to GitHub Container Registry (GHCR) on each push to `main`.

### Image URL:
```
ghcr.io/evanschalton/portainer-homepage:latest
```

Ensure the repository is public, or configure Portainer with credentials to pull private images from GHCR.

---

## How It Works

1. `setup.sh` runs when the container starts.
2. It scans all environment variables for `service-*-label` and `service-*-url` pairs.
3. It converts the key-value pairs into a sorted JSON list.
4. It injects that JSON into `template.html`, replacing `{{SERVICES_JSON}}`.
5. The rendered file is saved as `index.html` and served by NGINX.

