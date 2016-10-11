FROM ubuntu:xenial
MAINTAINER Ramiro Salas <rsalas@pivotal.io>

ENV HOME /home/ops
ENV ENAML /opt/enaml
ENV GOPATH $HOME/go
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/bin:/usr/local/go/bin:$GOPATH/bin

ADD update_enaml.sh /usr/local/bin

RUN mkdir $HOME
RUN mkdir $ENAML
RUN useradd -M -d $HOME ops
VOLUME $HOME
RUN chown -R ops: $HOME
WORKDIR $HOME
RUN mkdir -p $HOME/bin
RUN cp -n /etc/skel/.[a-z]* .

RUN cat /etc/apt/sources.list | sed 's/archive/us.archive/g' > /tmp/s && mv /tmp/s /etc/apt/sources.list

RUN apt-get update && apt-get -y --no-install-recommends install wget curl
RUN apt-get -y --no-install-recommends install \
           build-essential git ssh curl dnsutils golang \
           iputils-ping traceroute vim wget unzip sudo iperf \
           tcpdump nmap less netcat

RUN apt-get clean && apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "ops ALL=NOPASSWD: ALL" >> /etc/sudoers

USER ops

CMD ["/bin/bash"]
