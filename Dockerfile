# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.17

# set version label
ARG BUILD_DATE
ARG VERSION
ARG THELOUNGE_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca,nemchik"

# environment settings
ENV THELOUNGE_HOME="/config"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    build-base \
    git \
    python3-dev && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    yarn && \
  echo "**** install the lounge irc ****" && \
  if [ -z ${THELOUNGE_VERSION+x} ]; then \
    THELOUNGE_VERSION=$(curl -sX GET "https://api.github.com/repos/thelounge/thelounge/releases/latest" | jq -r '. | .tag_name'); \
  fi && \
  mkdir -p \
    /app/thelounge && \
  curl -o \
    /tmp/thelounge.tar.gz -L \
    "https://github.com/thelounge/thelounge/archive/refs/tags/${THELOUNGE_VERSION}.tar.gz" && \
  tar xf \
    /tmp/thelounge.tar.gz -C \
    /app/thelounge --strip-components=1 && \
  cd /app/thelounge && \
  yarn install && \
  NODE_ENV=production yarn build && \
  yarn link && \
  yarn --non-interactive cache clean && \
  echo "**** ensure public true on startup aka no users ****" && \
  sed -i "s/public: false,/public: true,/g" defaults/config.js && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /root \
    /tmp/* && \
  mkdir -p / \
    /root

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9000
VOLUME /config
