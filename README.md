# Portainer Homepage

This project creates a lightweight navigation homepage for Docker containers managed via Portainer.

![Home Page Example](/images/homepage.png)

It is designed for self-hosted environments where administrators want a simple way to list and link to internal services (e.g., Portainer, Neo4J, etc) without managing a full dashboard UI or remembering protocols and port numbers.

The homepage is served via NGINX and built from a configurable list of services defined via environment variables.

---

## Features

- Lightweight (based on `nginx:alpine`)
- Fully self-contained (no external assets)
- Configurable via key-value environment variables in the Portainer UI
- Designed for deployment via Portainer stacks
- Generates `index.html` at runtime using a shell script and HTML template
- Supports setting a `BASE_PATH` variable (useful if using a reverse proxy)

---

## Structure

```
app/
├── Dockerfile          # Builds the image from nginx and setup script
├── docker-compose.yml  # Forwards port 80 (+ optional env-vars)
├── setup.sh            # renders index.html from env-vars
├── template.html       # Template with JS to render the service list
├── nginx.conf          # (Optional) Custom nginx config
```

---

## Deployment (via Portainer)

You can deploy this as a Git-backed stack inside Portainer.

> You can optionally clone this repo, but it's meant to be fully managed by portainer's UI so there's no need unless you want to customize the css/html

### 1. Create a Stack

#### In the Portainer UI:
- Go to **Stacks** > **Add Stack**
- Choose **Git Repository**
- Paste the Git repo URL below
- Update the docker-compose referece from `docker-compose.yml` to `app/docker-compose.yml`

```
https://github.com/EvanSchalton/portainer-homepage
```

![Stack Creation](/images/stack_creation.png)

### 2. Example `docker-compose.yml`:
Alternatively, you can fork the repo and point to the docker-compose file.
You can optionally package your own instance of the docker container too.

```yaml
version: '3.8'

services:
  homepage:
    image: ghcr.io/evanschalton/portainer-homepage:latest
    ports:
      - "80:80"
    environment: {}
```

----

## Managing Services

You can add the environment variables (your services) in the stack creation step, but I prefer to deploy the stack then edit the container.

Navigate to the container and select `Duplicate/Edit`

![Container Editor Navigation](/images/environment_vars_navigation.png)

Navigate to the container and select `Duplicate/Edit`

![Container Editor Navigation](/images/environment_vars.png)


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

You can customize the webpage with a custom title and header using env vars as well:
| Key                    | Value      |
|------------------------|------------|
| `PAGE_TITLE` | `Portainer Services` |
| `TABLE_HEADER`   | `Services`       |
