FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# environment settings
ENV LOUNGE_HOME="/config" \
NPM_CONFIG_LOGLEVEL="info"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	nodejs-npm && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	nodejs && \
 echo "**** install the-lounge ****" && \
 mkdir -p \
	/app && \
 cd /app && \
 npm install \
	thelounge && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root && \
 mkdir -p / \
	/root

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9000
VOLUME /config
