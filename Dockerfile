FROM ubuntu:trusty
MAINTAINER Mark Lopez <m@silvenga.com>

RUN \
	DEBIAN_FRONTEND=noninteractive apt-get update
	
RUN \
	DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
	&& DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:deluge-team/ppa
	
RUN \
	apt-get update \
	&& apt-get install -y deluge-web deluged p7zip-full \
	&& apt-get clean

RUN \
	mkdir /config \
	&& chmod 777 /config \
	&& mkdir /torrents \
	&& chmod 777 /torrents

CMD \
	touch /config/deluged.log \
	&& /usr/bin/deluge-web -c /config --fork \
	&& /usr/bin/deluged -c /config -u 0.0.0.0 -i 0.0.0.0 -L info -l /config/deluged.log \
	&& tail -f /config/deluged.log
