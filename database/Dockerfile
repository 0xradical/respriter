FROM ruby:2.6.3-alpine

ARG DB_ENV=production
ENV DB_ENV $DB_ENV

ENV PS1="\[\033[01;34m\]\u(docker)\[\033[0m\] @ \[\033[01;32m\]\W\[\033[0m\] > "

ENV BUILD_PACKAGES="gettext curl curl-dev ruby-dev build-base bash libstdc++" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev graphviz font-bitstream-type1" \
    DATABASE_PACKAGES="postgresql-client postgresql-dev" \
    RUBY_PACKAGES="ruby-json yaml"

RUN apk update && \
    apk upgrade && \
    apk add --update $BUILD_PACKAGES $DEV_PACKAGES $DATABASE_PACKAGES $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /code

WORKDIR /code

COPY Gemfile      /code
COPY Gemfile.lock /code

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle install && \
    bundle clean

CMD ["/bin/bash"]
