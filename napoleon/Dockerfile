FROM ruby:2.5.3-slim

ARG USERNAME=developer
ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID $USERNAME                                                                                     && \
    useradd -m -u $UID -g $GID -s /bin/bash $USERNAME                                                              && \
    mkdir -p /home/$USERNAME                                                                                       && \
    echo 'export PS1="\[\033[01;34m\]\u(docker)\[\033[0m\] @ \[\033[01;32m\]\W\[\033[0m\] > "' >> /home/$USERNAME/.bashrc

ENV BUILD_PACKAGES="build-essential libpq-dev curl bash libstdc++ netcat sudo" \
    DEV_PACKAGES="gettext libxml2-dev libxslt-dev tzdata graphviz zlib1g zlib1g-dev libc6-dev liblzma-dev expect-dev git" \
    DATABASE_PACKAGES="postgresql-client-common postgresql-client-11" \
    RUBY_PACKAGES="ruby-json nodejs ruby-dev"

RUN apt-get update --no-install-recommends -qq                                                                                   && \
    apt-get install -y $BUILD_PACKAGES                                                                                           && \
    curl -sS -o - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add                                               && \
    echo "deb [arch=amd64]  http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/postgres.list && \
    apt-get update                                                                                                               && \
    apt-get install -y $DATABASE_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES                                                           && \
    rm -rf /var/lib/apt/lists/*                                                                                                  && \
    mkdir -p /app                                                                                                                && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /app

COPY Gemfile      /app
COPY Gemfile.lock /app

RUN bundle install && bundle clean

USER $USERNAME

CMD bundle exec rackup -s puma --port 4567 --host 0.0.0.0
