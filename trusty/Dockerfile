FROM  i386/ubuntu:trusty


RUN DEBIAN_FRONTEND=noninteractive; \
	apt-get -y -q update && \
	apt-get -y -q upgrade && \
	apt-get install -y -q git build-essential   gcc  binutils  automake libtool make cmake pkg-config busybox && \
	apt-get install -y -q libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev wget && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	
