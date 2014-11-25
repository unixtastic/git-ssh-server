## Standard phusion part
FROM phusion/baseimage:latest
ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh                            # Uncomment to Enable SSHD
#RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh    # Uncomment to Disable SSHD
CMD ["/sbin/my_init"]

## Expose ports.
EXPOSE 22

## Application specific part
MAINTAINER Stephen Day <sd@unixtastic.com>
WORKDIR /tmp
RUN apt-get -qq update && apt-get -qq upgrade
RUN apt-get -qq install git-sh git

## Setup service
# Setup a git user and SSH
RUN groupadd -g 987 git && useradd -g git -u 987 -d /git -m -r -s /usr/bin/git-shell git
RUN sed -i -e 's/.*LogLevel.*/LogLevel VERBOSE/' -e 's/#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i -e 's/#UsePAM.*/UsePAM no/' /etc/ssh/sshd_config

## Remove /etc/motd
RUN rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic 
RUN ln -fs /dev/null /run/motd.dynamic

## Clean up
WORKDIR /
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

