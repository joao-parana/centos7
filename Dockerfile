FROM centos:7.2.1511

MAINTAINER "João Antonio Ferreira" <joao.parana@gmail.com>

ENV REFRESHED_AT 2016-06-30

RUN yum -y update && yum -y install openssh-server passwd pwgen && yum clean all

# Systemd integration
#
# Systemd is included in the centos:7.2 base container, but it is not 
# active by default. In order to use systemd, I create this Dockerfile 

ENV container docker

# This Dockerfile deletes a number of unit files which might cause issues.

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/* ;

VOLUME [ "/sys/fs/cgroup" ]

# Setup do SSH Server
ENV AUTHORIZED_KEYS **None**
ADD create-ssh-user.sh /create-ssh-user.sh
ADD set_root_pw.sh /set_root_pw.sh

RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

RUN chmod 755 /create-ssh-user.sh

EXPOSE 22
RUN /create-ssh-user.sh

ADD start.sh /start.sh
RUN chmod 755 /start.sh

ENTRYPOINT ["/start.sh"]

