FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

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
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get -y update && \
    echo "**** install build packages ****" && \
    apt-get -y install --no-install-recommends \
        build-essential \
        git \
        libsharp-dev \
        libvips-dev \
        nodejs \
        npm \
        python3 \
        python3-dev && \
    echo "**** install runtime packages ****" && \
    apt-get -y install \
        curl \
        jq \
        yarn && \
    yarn config set unsafe-perm true && \
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
        node-gyp \
        sharp \
        sqlite3 && \
    yarn install && \
    NODE_ENV=production yarn build && \
    yarn cache clean && \
    echo "**** ensure public true on startup aka no users ****" && \
    sed -i "s/public: false,/public: true,/g" defaults/config.js && \
    echo "**** cleanup ****" && \
    apt-get -y purge --auto-remove \
        build-essential \
        git \
        libsharp-dev \
        libvips-dev \
        nodejs \
        npm \
        python3 \
        python3-dev && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/* \
        /root && \
    mkdir -p / \
        /root

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9000
VOLUME /config
