FROM golang:1.13.1-alpine

ENV LANG=en_US.UTF-8     \
    LANGUAGE=en_US.UTF-8 \
    PS1="\[\033[01;34m\]\u(docker)\[\033[0m\] @ \[\033[01;32m\]\W\[\033[0m\] > "

ARG DEP_VERSION=0.5.4
ENV DEP_VERSION $DEP_VERSION

ENV BUILD_PACKAGES="build-base bash git" \
    HTTP_PACKAGES="wget curl curl-dev"

RUN apk update                                      && \
    apk upgrade                                     && \
    apk add --update $BUILD_PACKAGES $HTTP_PACKAGES && \
    rm -rf /var/cache/apk/*

ADD https://github.com/golang/dep/releases/download/v$DEP_VERSION/dep-linux-amd64 /usr/bin/dep
RUN chmod +x /usr/bin/dep

WORKDIR /go/src/app

CMD ["/bin/bash"]
