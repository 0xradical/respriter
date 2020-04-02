# NOTE: THIS IMAGE SHOULD NOT BE USED IN PRODUCTION

# Packages:
# * Ruby
# * Common libs
# * Node.js

FROM ruby:2.6.5-slim
MAINTAINER codextremist <felipe.japm@gmail.com>

ARG UNAME=developer
ARG UID=1000
ARG GID=1000

ARG PACKAGES="apt-utils gettext sudo procps wget apt-transport-https gpg locales openssl graphviz libreadline-dev curl libcurl4-openssl-dev libssl-dev libapr1-dev libaprutil1-dev libx11-dev libffi-dev libpq-dev tcl-dev tk-dev git-core zlib1g zlib1g-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc-dev ncurses-dev libqt4-dev xvfb wkhtmltopdf libmagick++-dev libmagickwand-dev imagemagick python libfontconfig unzip postgresql-client-common postgresql-client-11"

RUN groupadd -g $GID $UNAME                                                                            && \
    useradd -m -u $UID -g $GID -s /bin/bash $UNAME                                                     && \
    mkdir -p /usr/share/man/man1 && mkdir -p /usr/share/man/man7                                       && \
    apt-get update --no-install-recommends -qq --fix-missing                                           && \
    apt-get install -qq -y --allow-unauthenticated $PACKAGES                                           && \
    locale-gen en_US.UTF-8                                                                             && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash -                                            && \
    apt-get update --no-install-recommends -qq --fix-missing                                           && \
    apt-get install -qq -y nodejs                                                                      && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -                             && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    apt update                                                                                         && \
    apt install -qq -y --no-install-recommends yarn                                                    && \
    gem install bundler --no-doc                                                                       && \
    echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf                                  && \
    mkdir -p /app                                                                                      && \
    chown $UNAME:$UNAME /app                                                                           && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /app

USER $UNAME

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=C

RUN echo 'export PS1="\[\033[01;34m\]\u\[\033[0m\] @ \[\033[01;32m\]\W\[\033[0m\] > "' >> /home/$UNAME/.bashrc
