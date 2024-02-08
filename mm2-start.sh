#!/bin/bash
cd /usr/local/bin/
if [ -z "$passphrase" ]
then
  source passphrase.txt
fi

if [ -z "$userpass" ]
then
  source userpass.txt
fi

if [ -z "$netid" ]
then
  source netid.txt
fi

stdbuf -oL mm2 "{\"gui\":\"komodefi\",\"netid\":$netid, \"userhome\":\"/${HOME#"/"}\", \"passphrase\":\"$passphrase\", \"rpc_password\":\"$userpass\", \"rpcip\": \"0.0.0.0\", \"rpc_local_only\": false, \"allow_weak_password\":true, \"dbdir\":\"/usr/local/bin\"}"
sleep 2
ps aux | grep mm2
