#!/bin/sh

# Convert SERVICES env var (YAML-style) to JSON
SERVICES_JSON=$(echo "$SERVICES" | awk -F': ' '
  BEGIN { printf "[" }
  {
    gsub(/^- /, "", $1);
    gsub(/"/, "\\\"", $1);
    gsub(/"/, "\\\"", $2);
    printf "%s{\"%s\":\"%s\"}", (NR==1?"":","), $1, $2;
  }
  END { print "]" }
')

# Inject into HTML
sed "s|{{ SERVICES_JSON }}|$SERVICES_JSON|g" /template.html > /usr/share/nginx/html/index.html

# Start nginx
exec nginx -g 'daemon off;'
