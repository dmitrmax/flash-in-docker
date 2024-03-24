
FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
ARG CHROMIUM_VERSION=65.0.3325.181-0ubuntu1

#ENV FLASH_VERSION=32.0.0.465
# Not latest but without timebomb
ENV FLASH_VERSION=32.0.0.371

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    chromium-browser=$CHROMIUM_VERSION \
    chromium-browser-l10n=$CHROMIUM_VERSION \
    chromium-codecs-ffmpeg-extra=$CHROMIUM_VERSION \
    faketime \
    pulseaudio-utils && \
    rm -rf /var/lib/apt/lists/* /var/cache/*

RUN adduser --gecos "user" --disabled-password --shell /bin/bash user && adduser user audio

ADD https://web.archive.org/web/20210000000000id_/https://fpdownload.adobe.com/get/flashplayer/pdc/$FLASH_VERSION/flash_player_ppapi_linux.x86_64.tar.gz /tmp
COPY etc /etc
COPY chromium-flash /usr/bin/
COPY pulse-client.conf /etc/pulse/client.conf

RUN mkdir -p /usr/lib/pepperflashplugin-nonfree && \
    tar -xz -f /tmp/flash_player_ppapi_linux.x86_64.tar.gz -C /usr/lib/pepperflashplugin-nonfree libpepflashplayer.so manifest.json && \
	chown root:root /usr/lib/pepperflashplugin-nonfree/libpepflashplayer.so && \
	chmod 644 /usr/lib/pepperflashplugin-nonfree/libpepflashplayer.so && \
	chown root:root /usr/lib/pepperflashplugin-nonfree/manifest.json && \
	chmod 644 /usr/lib/pepperflashplugin-nonfree/manifest.json

ENV DISPLAY=:0

# Run Chromium
CMD ["/usr/bin/chromium-flash"]
