FROM ruby:2.5.3-alpine

EXPOSE 9999

WORKDIR /app

RUN apk add --virtual build-dependencies ruby-dev build-base ruby-json && \
    gem install sinatra thin                                           && \
    apk del build-dependencies

COPY . /app

CMD ["rackup", "-s", "thin", "--port", "9999", "--host", "0.0.0.0"]
