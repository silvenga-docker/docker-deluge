FROM ubuntu:bionic

ARG PS_URL=https://github.com/PowerShell/PowerShell/releases/download/v7.0.3/powershell-lts_7.0.3-1.ubuntu.18.04_amd64.deb
ARG S6_URL=https://github.com/just-containers/s6-overlay/releases/download/v2.0.0.1/s6-overlay-amd64.tar.gz

RUN set -xe \
    && apt-get update \
    && apt-get install -y \
    gnupg \
    wget \
    p7zip-full \
    unrar \
    unzip \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C5E6A5ED249AD24C \
    && echo "deb http://ppa.launchpad.net/deluge-team/stable/ubuntu bionic main" >> /etc/apt/sources.list.d/deluge.list \
    && echo "deb-src http://ppa.launchpad.net/deluge-team/stable/ubuntu bionic main" >> /etc/apt/sources.list.d/deluge.list \
    && apt-get update \
    && apt-cache policy deluged \
    && apt-get install -y \
    "deluge-web=1.3.15-2" \
    "deluged=1.3.15-2" \
    "deluge-common=1.3.15-2" \
    "deluge-console=1.3.15-2" \
    && wget ${PS_URL} -O powershell.deb \
    && apt-get install -y ./powershell.deb \
    && rm ./powershell.deb \
    && wget ${S6_URL} -O s6-overlay-amd64.tar.gz \
    && tar vxzf s6-overlay-amd64.tar.gz -C / \
    && rm s6-overlay-amd64.tar.gz \
    && apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

COPY rootfs/ /

RUN set -xe \
    chmod +x -R /etc/services.d

EXPOSE 58846
EXPOSE 8112
VOLUME [ "/config" ]

CMD ["/init"]
