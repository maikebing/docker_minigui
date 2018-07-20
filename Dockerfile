FROM  i386/ubuntu:trusty
COPY tools/toolchain_R2_EABI.tar.zip /work/
COPY tools/toolchain_R2_EABI.tar.z01 /work/
COPY tools/toolchain_R2_EABI.tar.z02 /work/
COPY tools/toolchain_R2_EABI.tar.z03 /work/
COPY tools/toolchain_R2_EABI.tar.z04 /work/

COPY buildMiniGui.sh /work/
COPY buildProject.sh /work/
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y git build-essential   gcc  binutils  automake libtool make cmake pkg-config zip unzip  && \
    apt-get install -y libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev

RUN  cd /work/ && \
     cat toolchain_R2_EABI.tar.z* > toolchain_R2_EABI.zip && \
	 unzip toolchain_R2_EABI.zip && \
	 mv ./toolchain_R2_EABI.tar.gz_ ./toolchain_R2_EABI.tar.gz  && \
	 tar xzvf ./toolchain_R2_EABI.tar.gz

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

