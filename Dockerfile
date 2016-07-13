FROM centos:7.2.1511

MAINTAINER "João Antonio Ferreira" <joao.parana@gmail.com>

ENV REFRESHED_AT 2016-07-08

WORKDIR /tmp
# Required for install pwgen - http://www.itzgeek.com/how-tos/linux/centos-how-tos/enable-epel-repository-for-centos-7-rhel-7.html 
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && yum repolist && yum --disablerepo=* --enablerepo=epel list 
RUN yum -y update && yum -y install openssh-server passwd pwgen rsyslog && yum clean all

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

# Adding Apache web server
# RUN yum -y update 
RUN yum -y install apr
RUN yum -y install apr-util
RUN yum -y install centos-logos
RUN yum -y install httpd-tools
RUN yum -y install mailcap  
RUN yum -y install httpd 
# RUN yum clean all
# Automated build fail with this command
# RUN systemctl enable httpd.service

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 755 /start.sh

ENTRYPOINT ["/start.sh"]

