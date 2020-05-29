FROM postgres:11.4-alpine

RUN apk update               && \
    apk upgrade              && \
    apk add --update gettext && \
    rm -rf /var/cache/apk/*

WORKDIR /database

COPY .                   /database
COPY bin/docker-setup.sh /docker-entrypoint-initdb.d/setup.sh

CMD ["postgres"]
