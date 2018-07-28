FROM  i386/ubuntu:trusty
COPY arm/tools/toolchain.tar.gzaa /work/
COPY arm/tools/toolchain.tar.gzab /work/
COPY arm/tools/toolchain.tar.gzac /work/
COPY /arm/buildMiniGui_3_2.sh /work/
COPY /arm/buildProject.sh /work/
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y git build-essential   gcc  binutils  automake libtool make cmake pkg-config zip unzip  && \
    apt-get install -y libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev

RUN  cd /work/ && \
     cat toolchain.tar.gz* | tar xz && \
	 tar xzf ./toolchain_R2_EABI.tar.gz  \
	 rm /work/toolchain_R2_EABI.tar.gz && \
	 rm /work/toolchain.tar.gz*
	

RUN  cd ~/ && \
     git clone https://github.com/maikebing/build-minigui-3.2.git && \
     cd ~/build-minigui-3.2/  && \
     ./fetch-all.sh && \
     cd gvfb && \
     cmake .  && \
     make; sudo make install  && \
     cd .. && \
     cd 3rd-party/chipmunk-5.3.1 && \
     cmake . && \
     make && \
	 make install &&  \
	 cd ~/build-minigui-3.2/ && \
     cd minigui-res && \
     ./autogen.sh && \
     ./configure --prefix=/work/toolchain_R2_EABI/usr/arm-unknown-linux-gnueabi/sysroot/usr && \
     make install && \
     cd ..  && \
	 cd minigui && \
	 cp /work/buildMiniGui_3_2.sh ./  && \
	 chmod 777 ./buildMiniGui_3_2.sh  && \
	 ./buildMiniGui_3_2.sh && \
	 make && \
	 make install && \
	cd .. && \
	apt-get autoclean  && \
    rm /var/cache/apt/archives/* -R && \
	rm -rf /var/lib/apt/lists/*
