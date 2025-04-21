#!/bin/bash

if [ -n "$LOCAL_TESTING" ]; then
  export service_1_label="Service 1"
  export service_1_url="http://service1.example.com"
  export service_2_label="Service 2"
  export service_2_url="http://service2.example.com"
  export DEFAULT_DARK_MODE="true"
fi



# Collect and sort all service IDs (based on label keys)
SERVICE_IDS=$(env | grep '^service_.*_label=' | cut -d= -f1 | sed -E 's/^service_(.*)_label$/\1/' | sort)

# read the PAGE_TITLE env var, default to "Service List" if not set
if [ -z "$PAGE_TITLE" ]; then
  PAGE_TITLE="Portainer Services"
fi
# read the TABLE_HEADER env var, default to "Service List" if not set
if [ -z "$TABLE_HEADER" ]; then
  TABLE_HEADER="Services"
fi
# read the TABLE_HEADER env var, default to "Service List" if not set
if [ -z "$DEFAULT_DARK_MODE" ]; then
  DEFAULT_DARK_MODE="false"
fi

echo "Page Title: $PAGE_TITLE"
echo "Table Header: $TABLE_HEADER"
echo "Default Dark Mode: $DEFAULT_DARK_MODE"


echo "Service IDs: $SERVICE_IDS"
SERVICES_JSON="["

for id in $SERVICE_IDS; do
  label_var="service_${id}_label"
  url_var="service_${id}_url"

  label="${!label_var}"
  url="${!url_var}"

  # Only include if both are set
  if [ -n "$label" ] && [ -n "$url" ]; then
    SERVICES_JSON="${SERVICES_JSON}{\"$label\":\"$url\"},"
  fi
done

# Remove trailing comma and close array
if [ "$SERVICES_JSON" = "[" ]; then
  SERVICES_JSON="[]"
else
  SERVICES_JSON=$(echo "$SERVICES_JSON" | sed 's/,$/] /')
fi


# Inject into HTML
if [ -z "$LOCAL_TESTING" ]; then
  sed "s|{{ SERVICES_JSON }}|$SERVICES_JSON|g" /template.html > /usr/share/nginx/html/index.html
  sed -i "s|{{ PAGE_TITLE }}|$PAGE_TITLE|g" /usr/share/nginx/html/index.html
  sed -i "s|{{ TABLE_HEADER }}|$TABLE_HEADER|g" /usr/share/nginx/html/index.html
  sed -i "s|{{ DEFAULT_DARK_MODE }}|$DEFAULT_DARK_MODE|g" /usr/share/nginx/html/index.html
else
  sed "s|{{ SERVICES_JSON }}|$SERVICES_JSON|g" template.html > index.html
  sed -i "s|{{ PAGE_TITLE }}|$PAGE_TITLE|g" index.html
  sed -i "s|{{ TABLE_HEADER }}|$TABLE_HEADER|g" index.html
  sed -i "s|{{ DEFAULT_DARK_MODE }}|$DEFAULT_DARK_MODE|g" index.html
fi

# for local testing:
# sed "s|{{ SERVICES_JSON }}|$SERVICES_JSON|g" template.html > index.html

# Start nginx
exec nginx -g 'daemon off;'