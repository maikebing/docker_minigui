FROM  i386/ubuntu:trusty
COPY tools/toolchain.tar.gzaa /work/
COPY tools/toolchain.tar.gzab /work/
COPY tools/toolchain.tar.gzac /work/
COPY buildMiniGui.sh /work/
COPY buildProject.sh /work/
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y git build-essential   gcc  binutils  automake libtool make cmake pkg-config zip unzip  && \
    apt-get install -y libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev

RUN  cd /work/ && \
     cat toolchain.tar.gz* | tar xz && \
	 tar xzvf ./toolchain_R2_EABI.tar.gz /work/ && \
	 rm toolchain_R2_EABI*

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
	 cp /work/buildMiniGui.sh ./  && \
	 chmod 777 ./buildMiniGui.sh  && \
	 ./buildMiniGui.sh && \
	 make && \
	 make install && \
	 cd .. 

