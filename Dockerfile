# NOTE: THIS IMAGE SHOULD NOT BE USED IN PRODUCTION

# Packages:
# * Ruby
# * Common libs
# * ChromeDriver & Google Chrome
# * Node.js + phantomjs (required by the poltergeist gem)

FROM ruby:2.6.2-slim
MAINTAINER codextremist <felipe.japm@gmail.com>

ARG node_version=8.11.1
ARG chromedriver_version=73.0.3683.68
ARG yarn_version=1.15.2
ARG UNAME=developer
ARG UID=1000
ARG GID=1000

ENV PACKAGES="apt-utils sudo procps wget apt-transport-https gpg locales openssl graphviz libreadline-dev curl libcurl4-openssl-dev libssl-dev libapr1-dev libaprutil1-dev libx11-dev libffi-dev libpq-dev tcl-dev tk-dev git-core zlib1g zlib1g-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc-dev ncurses-dev libqt4-dev xvfb wkhtmltopdf libmagick++-dev libmagickwand-dev imagemagick python libfontconfig unzip postgresql-client-common postgresql-client"

RUN groupadd -g $GID $UNAME                                                                         && \
    useradd -m -u $UID -g $GID -s /bin/bash $UNAME                                                  && \
    mkdir -p /usr/share/man/man1 && mkdir -p /usr/share/man/man7                                    && \
    apt-get update --no-install-recommends -qq --fix-missing                                        && \
    apt-get install -qq -y $PACKAGES                                                                && \
    locale-gen en_US.UTF-8                                                                          && \
    mkdir /build                                                                                    && \
    cd /build                                                                                       && \
    wget http://nodejs.org/dist/v$node_version/node-v$node_version.tar.gz                           && \
    tar -xzf node-v$node_version.tar.gz                                                             && \
    cd /build/node-v$node_version                                                                   && \
    ./configure && make && make install                                                             && \
    rm -rf node-v$node_version                                                                      && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list          && \
    wget https://dl-ssl.google.com/linux/linux_signing_key.pub                                      && \
    apt-key add linux_signing_key.pub                                                               && \
    apt-get update --no-install-recommends -qq --fix-missing                                        && \
    apt-get install -qq -y google-chrome-stable                                                     && \
    wget https://chromedriver.storage.googleapis.com/$chromedriver_version/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip                                                                  && \
    mv chromedriver /usr/bin/chromedriver                                                           && \
    chown $UNAME:$UNAME /usr/bin/chromedriver                                                       && \
    chmod +x /usr/bin/chromedriver                                                                  && \
    cd /home/$UNAME                                                                                 && \
    rm -rf /build                                                                                   && \
    gem install bundler --no-doc                                                                    && \
    ln -s /home/$UNAME/.yarn/bin/yarn /usr/bin/yarn                                                 && \
    echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf                               && \
    mkdir -p /app                                                                                   && \
    chown $UNAME:$UNAME /app                                                                        && \
    echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /app

USER $UNAME

ENV NODE_PATH=/home/$UNAME/.config/yarn/global/node_modules
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=C

RUN echo 'export PS1="\[\033[01;34m\]\u\[\033[0m\] @ \[\033[01;32m\]\W\[\033[0m\] > "' >> /home/$UNAME/.bashrc && \
    mkdir -p ~/build                                                                                           && \
    cd    ~/build                                                                                              && \
    curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version $yarn_version                            && \
    yarn global add phantomjs-prebuilt                                                                         && \
    cd /app                                                                                                    && \
    rm -rf ~/build

COPY package.json /app
COPY yarn.lock    /app
RUN  yarn install --modules-folder=$NODE_PATH

COPY Gemfile      /app
COPY Gemfile.lock /app
RUN  bundle install
