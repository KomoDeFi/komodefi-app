#!/bin/bash
source /root/.bashrc
# setup the .env for the nodejs middleware
echo "
ME_PUBLIC=${ME_PUBLIC}
" > /node-cors-server/.env

### TODO re-implement after dc working
## generate the telegram config from passed in -e docker env vars
#echo "
##!/bin/bash
#TELEGRAM_BOT_TOKEN=\"${BOT_TOKEN}\"
#TELEGRAM_BOT_USERNAME=\"${BOT_USERNAME}\"
#TELEGRAM_BOT_CHATID=\"${BOT_CHATID}\"
#" > /usr/local/bin/telegram_info.txt

## send the wallet passphrase to users personal telegram channel
#/usr/local/bin/telegram_send.sh "Wallet passphrase ${passphrase}"

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
echo "Tunnel to the nodejs server"
echo "todo: ssh -g -L 7777:localhost:7777 -f -N root@${IPADDRESS}"

# copy mm2 executable and helper start scripts to somewhere in PATH
cp /node-cors-server/start-cors.sh /usr/local/bin/

# nodejs server, replace the userpass with the randomly generated one on container startup
sed -i "s/^const up\(.\)*$/const up = \"$userpass\"/" /node-cors-server/index.js
sed -i "s/^const UP\(.\)*$/const UP = \"$userpass\"/" /node-cors-server/mm2-middleware.js
sed -i "s/^const UP\(.\)*$/const UP = \"$userpass\"/" /node-cors-server/jl777coins/index.js



## NOV 23 2022
# the screen command and bash have been commented out
# and the node index.js just runs from this entrypoint
#cd /node-cors-server
#node index.js

#nvm use 14
# screen sessions started that start mm2, enable all coins, start the nodejs intermediate server & compile webapp
/usr/bin/screen -dmS cors bash -c '/usr/local/bin/start-cors.sh; exec bash'

# TODO disable in the future
# open a shell up for a user - requires docker run -i -t
/bin/bash
