FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# environment settings
ENV THELOUNGE_HOME="/config" \
NPM_CONFIG_LOGLEVEL="info"

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	nodejs-npm && \
 echo "**** install the lounge irc ****" && \
 mkdir -p \
	/app && \
 cd /app && \
 npm install -g \
	thelounge && \
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
