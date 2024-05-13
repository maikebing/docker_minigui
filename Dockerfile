FROM i386/debian:wheezy
COPY tools/arm-eabi-eMTC.tar.zip /work/
COPY tools/arm-eabi-eMTC.tar.z01 /work/
COPY tools/arm-eabi-eMTC.tar.z02 /work/
COPY tools/arm-eabi-eMTC.tar.z03 /work/
COPY tools/arm-eabi-eMTC.tar.z04 /work/

RUN 	echo "deb http://archive.debian.org/debian  wheezy main" > /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian  wheezy contrib" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian  wheezy non-free" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian-security wheezy  updates/main" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian-security wheezy  updates/contrib" >> /etc/apt/sources.list && \
	echo "deb http://archive.debian.org/debian-security wheezy  updates/non-free" >> /etc/apt/sources.list && \
	apt-get -y  --force-yes -q update && apt-get  install  -y --force-yes   -q  apt-transport-https ca-certificates &&   apt-get install ca-certificates && \
	apt-get install -y  --force-yes -q git build-essential   gcc  binutils  automake libtool make cmake pkg-config busybox-static unzip zip && \
	apt-get install -y  --force-yes -q libgtk2.0-dev libjpeg-dev libpng12-dev libfreetype6-dev libsqlite3-dev libxml2-dev wget  libconfig-dev && \
    apt-get install -y --force-yes -q openssh-server && \
	apt-get install -y --force-yes -q gdb gdbserver && \
	apt-get clean && apt-get autoremove   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	

RUN  cd /work/ && \
	cat  arm-eabi-eMTC.tar.* >  arm-eabi-eMTC_all.zip && \
	zip -FF  arm-eabi-eMTC_all.zip  --out arm-eabi-eMTC_all1.zip && \
	unzip -FF arm-eabi-eMTC_all1.zip && mv arm-eabi-eMTC.tar.gz1 arm-eabi-eMTC.tar.gz  && \
	tar xzf ./arm-eabi-eMTC.tar.gz && \
	rm /work/arm-eabi-eMTC.tar.gz && \
	rm /work/arm-eabi-eMTC.tar.z*
	
RUN  cd ~/ && \
	wget http://www.minigui.org/downloads/freetype-2.3.9-fm20100818.tar.gz && \
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
	
RUN cd ~/ && \
	wget https://curl.se/download/curl-7.80.0.tar.gz && \
	tar xzf curl-7.67.0.tar.gz 
	
RUN  cd ~/curl-7.67.0/ && \
     cp  /work/rebuildcurl.sh  ./ && \
	chmod 777 ./rebuildcurl.sh && \
	./rebuildcurl.sh arm && make install && \
	./rebuildcurl.sh x86 && make install && \
	make clean 

RUN rm ~/curl-7.67.0* -R && rm ~/freetype-2.3.9-fm20100818*  -R && rm ~/minigui2.0.4*  -R  

RUN mkdir /var/run/sshd
RUN echo 'root:1-q2-w3-e4-r5-t' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]	
