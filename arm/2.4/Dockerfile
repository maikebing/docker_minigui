FROM  i386/ubuntu:trusty
COPY ../tools/toolchain.tar.gzaa /work/
COPY ../tools/toolchain.tar.gzab /work/
COPY ../tools/toolchain.tar.gzac /work/
COPY ../buildProject.sh /work/
COPY buildMiniGui_2_4.sh /work/

RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y git build-essential   gcc  binutils  automake libtool make cmake pkg-config && \
    apt-get install -y libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev

RUN  cd ~/ && \
     git clone https://github.com/maikebing/minigui2.4.git && \
	 cp /work/buildMiniGui_2_4.sh ./  && \
	 chmod 777 ./buildMiniGui_2_4.sh  && \
	 ./buildMiniGui_2_4.sh && \
	 make && \
	 make install && 
