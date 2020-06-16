FROM node:12.18.0-alpine3.11
LABEL AUTHOR="Classpert"

ENV PATH="/app/.bin/:${PATH}"
RUN mkdir /app
WORKDIR /app

RUN npm install npm@latest -g

USER node
ENTRYPOINT ["npm"]
