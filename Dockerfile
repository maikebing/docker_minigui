FROM --platform=linux/386 i386/debian:wheezy
COPY tools/toolchain.tar.gzaa /work/
COPY tools/toolchain.tar.gzab /work/
COPY tools/toolchain.tar.gzac /work/
COPY tools/rebuildcurl.sh     /work/
COPY tools/rebuildlibusb.sh   /work/
COPY tools/curl-7.67.0.tar.gz /root/curl-7.67.0.tar.gz
COPY tools/freetype-2.3.9-fm20100818.tar.gz /root/freetype-2.3.9-fm20100818.tar.gz
COPY tools/libusb-1.0.11.tar.gz /root/libusb-1.0.11.tar.gz

RUN set -e; \
	retry() { \
		n=1; \
		while true; do \
			"$@" && return 0; \
			if [ "$n" -ge 5 ]; then return 1; fi; \
			echo "Retry $n/5: $*" >&2; \
			n=$((n + 1)); \
			sleep 5; \
		done; \
	}; \
	echo "deb http://archive.debian.org/debian  wheezy main" > /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian  wheezy contrib" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian  wheezy non-free" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian-security wheezy  updates/main" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian-security wheezy  updates/contrib" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian-security wheezy  updates/non-free" >> /etc/apt/sources.list && \
	retry apt-get -y --force-yes -q update && \
	retry apt-get install -y --fix-missing --force-yes -q git build-essential gcc binutils automake libtool make cmake pkg-config busybox-static ca-certificates && \
	retry apt-get install -y --fix-missing --force-yes -q libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev libconfig-dev libvncserver-dev && \
	retry apt-get install -y --fix-missing --force-yes -q openssh-server && \
	retry apt-get install -y --fix-missing --force-yes -q gdb gdbserver && \
	apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN  cd /work/ && \
	cat toolchain.tar.gz* | tar xz && \
	tar xzf ./toolchain_R2_EABI.tar.gz && \
	rm /work/toolchain_R2_EABI.tar.gz && \
	rm /work/toolchain.tar.gz*
	
RUN  cd ~/ && \
	tar xzf freetype-2.3.9-fm20100818.tar.gz && \
	cd freetype-2.3.9-fm20100818 && \
	./configure && \ 
	make && \
	make install && \
	make clean  && \
	cd ~/ && \
	git clone https://github.com/maikebing/minigui2.0.4.git && \
	cd  ./minigui2.0.4/  && \
	chmod 777 ./rebuildx86 && \
	./rebuildx86 && \
	make && \
	make install  && \
	make clean
	
 

RUN  cd ~/ && tar xzf  ~/curl-7.67.0.tar.gz
RUN  ls  ~/ && \
	cd ~/curl-7.67.0 && \
     cp  /work/rebuildcurl.sh  ./ && \
	chmod 777 ./rebuildcurl.sh && \
	./rebuildcurl.sh arm && make install && \
	./rebuildcurl.sh x86 && make install && \
	make clean 

RUN  cd ~/ && tar xzf ~/libusb-1.0.11.tar.gz
RUN  cd ~/libusb-1.0.11 && \
	cp /work/rebuildlibusb.sh ./ && \
	chmod 777 ./rebuildlibusb.sh && \
	./rebuildlibusb.sh arm && make install && \
	./rebuildlibusb.sh x86 && make install && \
	make clean

RUN rm -rf ~/curl-7.67.0* ~/libusb-1.0.11* ~/freetype-2.3.9-fm20100818* ~/minigui2.0.4*  

RUN mkdir /var/run/sshd
RUN echo 'root:1-q2-w3-e4-r5-t' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]	
