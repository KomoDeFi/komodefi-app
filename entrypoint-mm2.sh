#!/bin/bash

if [ ! -f "/passphrase.txt" ]; then
  echo "Generating passphrase"
  # generate random rpc userpass & wallet passphrase on startup
  userpass=$(cat /dev/urandom | tr -dc 'a-fA-F0-9' | fold -w 32 | head -n 1)
  passphrase=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

  # write the mm2 userpass & passphrase using randomly generated values
  echo "passphrase=$passphrase" > /passphrase.txt
  echo "userpass=$userpass" > /userpass.txt
  echo "netid=8762" > /netid.txt
else
  echo "passphrase.txt Mounted already by operator"
  source /passphrase.txt
  source /userpass.txt
  source /netid.txt
fi

ln -sf /passphrase.txt /usr/local/bin/
ln -sf /userpass.txt /usr/local/bin/
ln -sf /netid.txt /usr/local/bin/

# set the root password for this container to root.
# TODO generate random password and send over telegram
echo -e "root\nroot" | passwd root

# allow root login to container and start ssh
# TODO decide if this is needed for this app after dev is done
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
/etc/init.d/ssh start

# get ip and output some instructions for developers
IPADDRESS=`ifconfig | grep inet | grep -v 127 | awk -F ' ' '{print $2}'`
echo "For developers:"
echo "The root password is root"
echo "Tunnel to marketmaker with ssh allowing your to use curl commands from host to http://localhost:7783/"
echo "mm2: ssh -g -L 7783:localhost:7783 -f -N root@${IPADDRESS}"

# screen sessions started that start mm2, enable all coins, start the nodejs intermediate server & compile webapp
/usr/bin/screen -dmS mm2 bash -c 'cd /usr/local/bin; /usr/local/bin/start.sh; exec bash' 

# TODO disable in the future
# open a shell up for a user - requires docker run -i -t
/bin/bash
