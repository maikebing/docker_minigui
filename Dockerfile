FROM i386/debian:wheezy
COPY tools/toolchain.tar.gzaa /work/
COPY tools/toolchain.tar.gzab /work/
COPY tools/toolchain.tar.gzac /work/
COPY tools/rebuildcurl.sh     /work/
COPY tools/curl-7.67.0.tar.gz /root/curl-7.67.0.tar.gz

RUN 	echo "deb http://archive.debian.org/debian  wheezy main" > /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian  wheezy contrib" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian  wheezy non-free" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian-security wheezy  updates/main" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian-security wheezy  updates/contrib" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian-security wheezy  updates/non-free" >> /etc/apt/sources.list && \
	apt-get -y  --force-yes -q update && \
	apt-get install -y  --force-yes -q git build-essential   gcc  binutils  automake libtool make cmake pkg-config busybox-static  ca-certificates && \
	apt-get install -y  --force-yes -q libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev wget  libconfig-dev libvncserver-dev  && \
        apt-get install -y --force-yes -q openssh-server && \
	apt-get install -y --force-yes -q gdb gdbserver && \
	apt-get clean && apt-get autoremove   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	

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
	make clean  && \
	rm ~/freetype-2.3.9-fm20100818*  -R && \
	cd ~/ && \
	git clone https://github.com/maikebing/minigui2.0.4.git && \
	cd  ./minigui2.0.4/  && \
	chmod 777 ./rebuildx86 && \
	./rebuildx86 && \
	make && \
	make install  && \
	make clean  &&\
	rm ~/minigui2.0.4*  -R 
	
 

RUN  cd ~/ && tar xzf  ~/curl-7.67.0.tar.gz && \
     ls  ~/ && \
	cd ~/curl-7.67.0 && \
     cp  /work/rebuildcurl.sh  ./ && \
	chmod 777 ./rebuildcurl.sh && \
	./rebuildcurl.sh arm && make install && \
	./rebuildcurl.sh x86 && make install && \
	make clean  &&\
	rm ~/curl-7.67.0* -R 
	
RUN  cd ~/ && https://github.com/confluentinc/librdkafka.git && \
	cd ~/librdkafka && \
     git checkout  v2.13.2 -f ./ && \
	./configure --cc=/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-gcc \
				--cxx=/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-g++ \
				--arch=arm --target=arm-unknown-linux-gnueabi --host=arm-unknown-linux-gnueabi --build=i686-pc-linux-gnu \
				--prefix=/work/toolchain_R2_EABI/usr/arm-unknown-linux-gnueabi/sysroot/usr --pkg-config-path=/work/toolchain_R2_EABI/usr/bin/pkg-config  \
				--CFLAGS="-g0" --LDFLAGS="-L/work/toolchain_R2_EABI/lib -L/work/toolchain_R2_EABI/usr/lib -Wl,-rpath,/work/toolchain_R2_EABI/usr/lib" \
				--enable-static \
				--disable-ssl  --disable-gssapi  --disable-sasl  --disable-curl  --disable-lz4-ext   --disable-lz4   --disable-regex-ext  --disable-c11threads   \
				--disable-syslog --disable-valgrind  && \
	./make  && make install && \
	make clean  &&\
	./configure      --CFLAGS="-g0"   --enable-static --disable-ssl  --disable-gssapi  --disable-sasl  --disable-curl  --disable-lz4-ext   --disable-lz4   --disable-regex-ext  --disable-c11threads    --disable-syslog --disable-valgrind  
	./make  && make install && \
	make clean  &&\
	rm  ~/librdkafka -R 

RUN mkdir /var/run/sshd
RUN echo 'root:1-q2-w3-e4-r5-t' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]	
