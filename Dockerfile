FROM  i386/ubuntu:trusty
RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y git

RUN  cd ~/ && \
     git clone https://github.com/maikebing/build-minigui-3.2.git && \
     cd ~/build-minigui-3.2/ && \
     ./build-all.sh
     


