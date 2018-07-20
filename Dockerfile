FROM  i386/ubuntu:trusty
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y git build-essential   gcc  binutils  automake libtool make cmake pkg-config && \
    apt-get install -y libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev

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
     make; sudo make install &&  \
     cd ../.. && tools/toolchain_R2_EABI.tar.zip  /work/ && \
	 unzip 
     cd minigui-res && \
     ./autogen.sh && \
     ./configure --prefix=/work/toolchain_R2_EABI/usr/arm-unknown-linux-gnueabi/sysroot/usr && \
     make install && \
     cd ..  && \
	 cd minigui && \
	 chmod 777 ./buildMiniGui.sh ; ./buildMiniGui.sh && \
	 make;  make install && \
	 cd .. && \

