#!/bin/bash

set -e

if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
  echo "=> Found authorized keys"
  mkdir -p /root/.ssh
  chmod 700 /root/.ssh
  touch /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
  IFS=$'\n'
  arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
  for x in $arr
  do
    x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
    cat /root/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo "••• `date` - => Adding public key to /root/.ssh/authorized_keys: $x"
      echo "$x" >> /root/.ssh/authorized_keys
    fi
  done
fi

if [ ! -f /.root_pw_set ]; then
  echo "••• `date` - Estabelecendo a senha de root para o SSH "
  /set_root_pw.sh "$ROOT_PASSWORD"
fi

if [ -f /.root_pw_set ]; then
  echo "••• `date` - Senha de root para o SSH já foi definida"
fi

echo "••• `date` - - - - - - Iniciando o SSH Server - - - - - - - - - "
/usr/sbin/sshd -D &
echo "••• `date` - - - - - - SSH Server Iniciado  - - - - - - - - - - "
# 
if [ "$1" = 'init' ]; then
    echo "••• `date` - Iniciando o Systemd"
#   /usr/sbin/init
    systemctl start httpd.service
    /bin/bash
    exit 0
fi

echo "••• `date` - - - -  No macOS e no Windows não roda o systemctl   - - - - "

echo "••• `date` - - - - - - ENTRYPOINT com parametro: $1  - - - - - - - - - - "
if [ "$1" = 'bash' ]; then
    echo "••• `date` - - - - - - Iniciando o Apache WEB Server - - - - - - - - - "
    # systemctl start httpd.service
    /usr/sbin/apachectl
    curl http://localhost
    ps -ef 
    echo "••• `date` - Iniciando Bash shell"
    /bin/bash
    exit 0
fi
# /sbin/init
# sleep 200000000

