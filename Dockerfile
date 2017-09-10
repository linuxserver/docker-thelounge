FROM lsiobase/alpine:3.6
MAINTAINER Gonzalo Peci, sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# environment settings
ENV NPM_CONFIG_LOGLEVEL info

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	nodejs-npm && \

# install runtime packages
 apk add --no-cache \
	nodejs && \

# install shout-irc
 mkdir -p \
	/app && \
 cd /app && \
 npm install \
	thelounge && \

# cleanup
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

# environment variables
ENV PATH="/app/node_modules/.bin:$PATH"
ENV LOUNGE_HOME="/config"
