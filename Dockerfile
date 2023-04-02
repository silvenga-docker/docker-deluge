FROM ubuntu:jammy AS base

LABEL maintainer "Mark Lopez <m@silvenga.com>"

ARG URL_7Z=https://7-zip.org/a/7z2201-linux-x64.tar.xz
ARG URL_PS=https://github.com/PowerShell/PowerShell/releases/download/v7.2.10/powershell-lts_7.2.10-1.deb_amd64.deb
ARG S6_OVERLAY_VERSION=3.1.4.1

RUN set -xe \
    && apt-get update \
    && apt-get dist-upgrade -y \
    # Common
    && apt-get install -y \
    wget \
    software-properties-common \
    # Powershell
    && wget ${URL_PS} -O powershell.deb \
    && apt-get install -y ./powershell.deb \
    && rm powershell.deb \
    # 7zz
    && wget ${URL_7Z} -O 7z.tar.xz \
    && tar xvf 7z.tar.xz -C /tmp/ \
    && install /tmp/7zz /usr/bin/7zz \
    && install /tmp/7zz /usr/bin/7z \
    && rm 7z.tar.xz \
    # Init
    && wget https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz -O s6-overlay-noarch.tar.xz \
    && wget https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz -O s6-overlay-x86_64.tar.xz \
    && tar -C / -Jxpf s6-overlay-noarch.tar.xz \
    && tar -C / -Jxpf s6-overlay-x86_64.tar.xz \
    && rm s6-overlay-noarch.tar.xz \
    && rm s6-overlay-x86_64.tar.xz \
    # Deluge
    && apt-add-repository ppa:deluge-team/stable \
    && apt-get install -y \
    deluged \
    deluge-common \
    deluge-web \
    unrar \
    unzip \
    && mkdir /config \
    # User
    && groupadd deluge --gid 1000 \
    && adduser deluge --uid 1000 --gid 1000 --disabled-password --gecos "" \
    # Cleanup
    && apt-get purge -y software-properties-common wget \
    && apt-get autoremove -y --purge \
    && apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

COPY rootfs/ /

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_KEEP_ENV=1 \
    PYTHON_EGG_CACHE=/tmp/ \
    NICENESS=10

VOLUME [ "/config" ]
ENTRYPOINT ["/init"]
