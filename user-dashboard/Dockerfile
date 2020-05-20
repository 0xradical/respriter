FROM node:10.16.1-alpine AS builder
MAINTAINER "Dalton Pinto" <dalton@classpert.com>

ARG GITHUB_ACCESS_TOKEN

USER node

COPY --chown=node:node . /app
WORKDIR /app

RUN rm -rf node_modules && mkdir -p node_modules && npm ci

FROM node:10.16.1-alpine

RUN apk --no-cache add sudo && \
    echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER node

RUN sudo mkdir -p /app && sudo chown node:node /app
WORKDIR /app

COPY --from=builder --chown=node:node /app/node_modules /app/node_modules

CMD npm run serve
