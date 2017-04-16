FROM lsiobase/alpine:3.5
MAINTAINER Gonzalo Peci, sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# environment settings
ENV NPM_CONFIG_LOGLEVEL=info USERS=no

# install packages
RUN \
 apk add --no-cache \
	nodejs && \

# install shout-irc
 mkdir -p \
	/app && \
 cd /app && \
 npm install \
	thelounge && \

# cleanup
 npm cache clean

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9000
VOLUME /config
