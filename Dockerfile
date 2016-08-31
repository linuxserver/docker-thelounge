FROM lsiobase/alpine
MAINTAINER Gonzalo Peci, sparklyballs

# environment settings
ENV NPM_CONFIG_LOGLEVEL info

# install packages
RUN \
 apk add --no-cache \
	nodejs && \

# install shout-irc
 mkdir -p \
	/app && \
 cd /app && \
 npm install \
	css-select \
	shout && \

# cleanup
 npm cache clean

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9000
VOLUME /config
