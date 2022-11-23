# komodefi app

## tl;dr;
Clone + change passphrase + docker-compose up. Wait for webapp to build in devmode 1 minute should be plenty, browse to 127.0.0.1:17077

## Notes

The 3 containers work in concert.
* mm2 is the atomicdex api, it will communicate with the atomicdex p2p network on the configured netid. Currently hardcoded to 7777.
* mm2-middleware is a nodejs http app that accepts requests and relays them to the mm2 rpc. It is not really safe for building a commercial application because a lot of the dependencies are unmaintained.
* mm2-frontend is a vuetify 2 app. This is nearly end of life as at November 2022.

## Requirements

This requires docker & docker-compose.
Running with various like
```
docker version 20.10.XX
docker-compose version 2.2.2 & 2.11.2
```

## Installation

```
git clone https://github.com/komodefi/komodefi-app
cd komodefi-app
./setup.sh
```

This will build 3 docker images
```
komodefi/mm2-frontend             0.1                         c703d57767e0   42 minutes ago   1.08GB
komodefi/mm2-middleware           0.1                         a38d88562fdd   47 minutes ago   460MB
komodefi/mm2                      0.1                         2af13f7ad038   9 days ago       943MB
```

## Configure

Copy the sample env.sample to .env and modify the value of `MM2_WALLET_PASSPHRASE`. Make it a long string and random, something like:
```
$ cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
y2RlQWJxWWFAg4VGwTQqVqupDNh2AQC1
```
Save this random string of character, it is the passphrase for all supported wallets of atomicdex api.

The other port settings work as is, but you might have specific ports unavailable on your own system.
`MM2_MIDDLEWARE_PORT` must usually be the same as the port number in `MMBOT_URL`.

`MMBOT_URL` can be any IP address you are running this software from, but it is a web app and anyone inside your local network may be able to browse to it.

`ME_PUBLIC` & `ME_PRIVATE` are settings for enabling the person browsing the app to place orders. When `ME_PRIVATE` is set to true and `ME_PUBLIC` is set to false, orders will be able to be placed.

## Running

```
docker-compose up
```

If you clone this repo and do not change the `MM2_WALLET_PASSPHRASE` from `komodefi`, the addresses will be `1JpvQVyphiUn8W935dfPosnVemih37q2XR` for bitcoin & `RT77V1s7JYHMCWWEYoeWuQ7hR3BHgysQXS` for the komodo family of coins. Other similarly derived addresses will be available for different cryptocurrencies.

If you use the passphrase from the example above `y2RlQWJxWWFAg4VGwTQqVqupDNh2AQC1`, the bitcoin address will be `1Kh8hh8joxf9KqK4HGCVSKXPFPDRy6udBu` & the komodo family of addresses will be `RTyKnD22QnTiPqgFkSBcXqrb1eg2cT7HKW`.

AI or a human that is smarter and more calculating will probably be monitoring these wallets for any deposits - so best to come up with a better random passphrase than what exists in this repo.
