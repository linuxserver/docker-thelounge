FROM ghcr.io/linuxserver/baseimage-alpine:3.13

# set version label
ARG BUILD_DATE
ARG VERSION
ARG THELOUNGE_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca,nemchik"

# environment settings
ENV THELOUNGE_HOME="/config" \
NPM_CONFIG_LOGLEVEL="info"

RUN \
	echo "**** install build packages ****" && \
	apk add --no-cache --virtual=build-dependencies \
		gcc \
		git \
		g++ \
		make \
		python2-dev && \
	echo "**** install runtime packages ****" && \
	apk add --no-cache \
		curl \
		jq \
		nodejs-npm \
		yarn && \
	npm config set unsafe-perm true && \
	echo "**** install the lounge irc ****" && \
	if [ -z ${THELOUNGE_COMMIT+x} ]; then \
		THELOUNGE_COMMIT=$(curl -s https://api.github.com/repos/thelounge/thelounge/commits/master \
		| jq -r '. | .sha' | cut -c1-8 ); \
	fi && \
	mkdir -p \
		/app/thelounge && \
	curl -o \
		/tmp/thelounge.tar.gz -L \
        "https://github.com/thelounge/thelounge/archive/${THELOUNGE_COMMIT}.tar.gz" && \
	tar xf \
		/tmp/thelounge.tar.gz -C \
        /app/thelounge --strip-components=1 && \
	cd /app/thelounge && \
	npm install -g \
		sqlite3 && \
	yarn install && \
	NODE_ENV=production yarn build && \
	yarn cache clean && \
	echo "**** ensure public true on startup aka no users ****" && \
	sed -i "s/public: false,/public: true,/g" defaults/config.js && \
	echo "**** cleanup ****" && \
	apk del --purge \
		build-dependencies && \
	rm -rf \
		/tmp/* \
		/root && \
	mkdir -p / \
		/root

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9000
VOLUME /config
