FROM nginx:alpine

RUN apk add --no-cache bash

COPY setup.sh /setup.sh
COPY styles.css /usr/share/nginx/html/styles.css
COPY template.html /template.html

RUN chmod +x /setup.sh

CMD ["/setup.sh"]
