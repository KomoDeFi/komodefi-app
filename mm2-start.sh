#!/bin/bash
cd /usr/local/bin/
source passphrase.txt
source userpass.txt
source netid.txt
stdbuf -oL mm2 "{\"gui\":\"komodefi\",\"netid\":$netid, \"userhome\":\"/${HOME#"/"}\", \"passphrase\":\"$passphrase\", \"rpc_password\":\"$userpass\", \"rpcip\": \"0.0.0.0\", \"rpc_local_only\": false, \"allow_weak_password\":true, \"dbdir\":\"/usr/local/bin\"}"
sleep 2
ps aux | grep mm2
