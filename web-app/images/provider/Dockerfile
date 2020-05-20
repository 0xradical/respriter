FROM nginx:alpine
MAINTAINER "Dalton Pinto" <dalton@classpert.com>

COPY ./nginx.conf           /etc/nginx/nginx.conf
COPY ./docker-entrypoint.sh /home/root/docker-entrypoint.sh

ENTRYPOINT ["/home/root/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
