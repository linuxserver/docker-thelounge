FROM ghcr.io/linuxserver/baseimage-alpine:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
ARG THELOUNGE_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# environment settings
ENV THELOUNGE_HOME="/config" \
NPM_CONFIG_LOGLEVEL="info"

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	curl \
	jq \
	nodejs-npm && \
 npm config set unsafe-perm true && \
 echo "**** install the lounge irc ****" && \
 if [ -z ${THELOUNGE_VERSION+x} ]; then \
	THELOUNGE_VERSION=$(curl -sL https://replicate.npmjs.com/registry/thelounge \
	|jq -r '. | .["dist-tags"].latest'); \
 fi && \
 mkdir -p \
	/app && \
 cd /app && \
 npm install -g \
	thelounge@${THELOUNGE_VERSION} && \
 echo "**** ensure public true on startup aka no users ****" && \
 sed -i "s/public: false,/public: true,/g" /usr/lib/node_modules/thelounge/defaults/config.js && \
 echo "**** cleanup ****" && \
 rm -rf \
	/root && \
 mkdir -p / \
	/root

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9000
VOLUME /config
