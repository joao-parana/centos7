FROM centos:7.2

MAINTAINER "João Antonio Ferreira" <joao.parana@gmail.com>

RUN yum -y update && yum clean all

# Systemd integration
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

CMD ["/usr/sbin/init"]

