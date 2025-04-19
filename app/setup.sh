#!/bin/sh

# Collect and sort all service IDs (based on label keys)
SERVICE_IDS=$(env | grep '^service-.*-label=' | cut -d= -f1 | sed -E 's/^service-(.*)-label$/\1/' | sort)

SERVICES_JSON="["

for id in $SERVICE_IDS; do
  label_var="service-${id}-label"
  url_var="service-${id}-url"

  label="${!label_var}"
  url="${!url_var}"

  # Only include if both are set
  if [ -n "$label" ] && [ -n "$url" ]; then
    SERVICES_JSON="${SERVICES_JSON}{\"$label\":\"$url\"},"
  fi
done

# Remove trailing comma and close array
SERVICES_JSON=$(echo "$SERVICES_JSON" | sed 's/,$/] /')

# Inject into HTML
sed "s|{{ SERVICES_JSON }}|$SERVICES_JSON|g" /template.html > /usr/share/nginx/html/index.html

# Start nginx
exec nginx -g 'daemon off;'
