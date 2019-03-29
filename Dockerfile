# NOTE: THIS IMAGE SHOULD NOT BE USED IN PRODUCTION

# Packages:
# * Ruby
# * Common libs
# * ChromeDriver & Google Chrome
# * Node.js + phantomjs (required by the poltergeist gem)

FROM debian:latest

# Set package versions
ARG node_version=8.11.1
ARG ruby_version=2.6.2
ARG ruby_minor=2.6
ARG chromedriver_version=73.0.3683.68

# Set User
ARG UNAME=developer
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME

MAINTAINER codextremist <felipe.japm@gmail.com>

#### Install Common Libs and Apps required by RoR and popular gems
RUN apt-get update --fix-missing && apt-get install -qy build-essential \
sudo \
procps \
wget \
apt-transport-https \
locales \
openssl \
graphviz \
libreadline-dev \
curl \
libcurl4-openssl-dev \
libssl-dev \
libapr1-dev \
libaprutil1-dev \
libx11-dev \
libffi-dev \
libpq-dev \
tcl-dev \
tk-dev \
git-core \
zlib1g zlib1g-dev \
libyaml-dev \
libxml2-dev \
libxslt-dev \
autoconf \
libc-dev \
ncurses-dev \
libqt4-dev \
xvfb \
wkhtmltopdf \
libmagick++-dev \
libmagickwand-dev \
imagemagick \
python \
libfontconfig \
unzip \
postgresql-client-9.6


RUN mkdir /build

# Install Ruby
WORKDIR /build
RUN wget -qO- http://cache.ruby-lang.org/pub/ruby/$ruby_minor/ruby-$ruby_version.tar.gz | tar xvz &&\
cd ruby-$ruby_version &&\
./configure --disable-install-doc --disable-install-rdoc --disable-install-capi &&\
make &&\
make install

# Install Node
RUN wget http://nodejs.org/dist/v$node_version/node-v$node_version.tar.gz
RUN tar -xzf node-v$node_version.tar.gz
WORKDIR /build/node-v$node_version
RUN ./configure && make && make install

# Install Yarn
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN apt-get update && apt-get install -qy libuv1
# RUN apt-get install --no-install-recommends yarn

# RUN yarn global add phantomjs-prebuilt 

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL C

# Clean build dirs
RUN rm -rf node-v$node_version

RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list
RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub
RUN apt-key add linux_signing_key.pub
RUN apt-get update
RUN apt-get install -qy google-chrome-stable
RUN apt-get install -qy sudo

# Install ChromeDriver
RUN wget https://chromedriver.storage.googleapis.com/$chromedriver_version/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver
RUN chown developer:developer /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver

RUN rm -rf /build

# Avoid FS issues with Guard and Webpacker (hot reload)
RUN echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf

# Install Bundler
RUN gem install bundler --no-doc
RUN mkdir /app
ENV BUNDLE_PATH /app/.bundle
WORKDIR /app
ARG yarn_version=1.15.2

# Install Yarn
RUN ln -s /home/$UNAME/.yarn/bin/yarn /usr/bin/yarn
USER $UNAME
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version $yarn_version
RUN yarn global add phantomjs-prebuilt 
