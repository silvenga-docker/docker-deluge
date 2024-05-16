FROM ubuntu:noble AS base

LABEL org.opencontainers.image.authors "Mark Lopez <m@silvenga.com>"

ARG URL_7Z=https://7-zip.org/a/7z2405-linux-x64.tar.xz
ARG S6_OVERLAY_VERSION=3.1.6.2

# No release of PWSH for 22.04 yet.
ARG VERSION_ID=22.04

RUN set -xe \
    && apt-get update \
    && apt-get dist-upgrade -y \
    # Common
    && apt-get install -y \
    wget \
    software-properties-common \
    apt-transport-https \
    # Powershell
    # HACK START
    # https://github.com/PowerShell/PowerShell/issues/21385#issuecomment-2113021320
    && wget -q https://launchpad.net/ubuntu/+archive/primary/+files/libicu72_72.1-3ubuntu3_amd64.deb -O libicu72_72.1-3ubuntu3_amd64.deb \
    && dpkg -i libicu72_72.1-3ubuntu3_amd64.deb \
    && rm libicu72_72.1-3ubuntu3_amd64.deb \
    # HACK END
    && wget -q https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && apt-get install -y ./packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell \
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
    && apt-get install -y \
    deluged \
    deluge-common \
    deluge-web \
    deluge-console \
    unrar \
    unzip \
    dnsutils \
    && mkdir /config \
    # Cleanup
    && apt-get purge -y software-properties-common wget \
    && apt-get autoremove -y --purge \
    && apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

COPY rootfs/ /

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_KEEP_ENV=1 \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    POWERSHELL_TELEMETRY_OPTOUT=1 \
    PYTHON_EGG_CACHE=/tmp/ \
    NICENESS=10

VOLUME [ "/config" ]
ENTRYPOINT ["/init"]
