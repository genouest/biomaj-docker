FROM nginx

LABEL traefik.enable=true
LABEL traefik.frontend.rule=PathPrefix:/db

COPY default.conf /etc/nginx/conf.d/default.conf
