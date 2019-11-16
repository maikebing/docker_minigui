FROM  i386/ubuntu:trusty
COPY tools/toolchain.tar.gzaa /work/
COPY tools/toolchain.tar.gzab /work/
COPY tools/toolchain.tar.gzac /work/

RUN DEBIAN_FRONTEND=noninteractive; \
	apt-get -y -q update && \
	apt-get -y -q upgrade && \
	apt-get install -y -q git build-essential   gcc  binutils  automake libtool make cmake pkg-config && \
	apt-get install -y -q libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev wget && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	

RUN  cd /work/ && \
	cat toolchain.tar.gz* | tar xz && \
	tar xzf ./toolchain_R2_EABI.tar.gz && \
	rm /work/toolchain_R2_EABI.tar.gz && \
	rm /work/toolchain.tar.gz*

RUN  cd ~/ && \
	wget http://www.minigui.org/downloads/freetype-2.3.9-fm20100818.tar.gz && \
	tar xzf freetype-2.3.9-fm20100818.tar.gz && \
	cd freetype-2.3.9-fm20100818 && \
	./configure && \
	make && \
	make install && \
	cd ~/ && \
	git clone https://github.com/maikebing/minigui2.0.4.git && \
	cd  ./minigui2.0.4/  && \
	chmod 777 ./rebuildx86 && \
	./rebuildx86 && \
	make clean  && \
	make && \
	make install  && \
	make clean