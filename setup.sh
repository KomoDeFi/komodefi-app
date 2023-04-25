#!/bin/bash
./build-mm2.sh
./build-mm2-middleware.sh
./build-mm2-vuetify3.sh
cp env.sample .env
sed -i s/XX_komodefi_XX/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 45 | head -n 1)/g .env
sed -i s/XX_rpcpassword_XX/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 17 | head -n 1)/g .env
sed -i s/XX_myip_XX/$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)/g .env
