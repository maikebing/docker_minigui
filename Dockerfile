FROM  i386/ubuntu:trusty
COPY tools/toolchain.tar.gzaa /work/
COPY tools/toolchain.tar.gzab /work/
COPY tools/toolchain.tar.gzac /work/
COPY buildProject.sh /work/

RUN apt-get update && \
	apt-get -y upgrade && \
	apt-get install -y git build-essential   gcc  binutils  automake libtool make cmake pkg-config && \
	apt-get install -y libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev wget 

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
	git clone https://github.com/maikebing/minigui2.0.4.git && \
	cd  ./minigui2.4/  && \
	chmod 777 ./rebuildx86 && \
	./rebuildx86 && \
	make clean  && \
	make && \
	make install  && \
	make clean