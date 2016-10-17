FROM ubuntu:trusty
MAINTAINER Mark Lopez <m@silvenga.com>

RUN \
	DEBIAN_FRONTEND=noninteractive apt-get update &&\
	DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common &&\
	DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:deluge-team/ppa
	
RUN \
	DEBIAN_FRONTEND=noninteractive apt-get update &&\
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
		deluge-web=1.3.13-0~trusty~ppa1 \
		deluged=1.3.13-0~trusty~ppa1 \
		p7zip-full &&\
	DEBIAN_FRONTEND=noninteractive apt-get clean

RUN \
	mkdir /config &&\
	chmod 777 /config &&\
	mkdir /torrents &&\
	chmod 777 /torrents

CMD \
	touch /config/deluged.log &&\
	/usr/bin/deluge-web -c /config --fork &&\
	/usr/bin/deluged -c /config -u 0.0.0.0 -i 0.0.0.0 -L info -l /config/deluged.log &&\
	tail -f /config/deluged.log
