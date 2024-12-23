# [eagleslinedancers.ch](https://eagleslinedancers.ch)

[![Netlify Status](https://api.netlify.com/api/v1/badges/0fa1fc46-6b5a-4547-89e0-8637b24431fa/deploy-status)](https://app.netlify.com/sites/relaxed-haibt-13e6cb/deploys)

## Development

### Nix

```sh
nix develop # starts a shell environment
```

## Update/Upgrade

Ubuntu OS

```sh
sudo apt update
sudo apt upgrade

# needs a reboot

do-release-upgrade

# needs another reboot
```

## Troubleshooting

This are very hacky/temporary solutions. Longterm Goal: Move to a NixOS server.

### `'xterm-kitty': unknown terminal type.`

run `export TERM=xterm-256color`

### No connection

Add an IP like 8.8.8.8 to the `/etc/resolv.conf` as `nameserver` e.g. run `echo "nameserver 8.8.8.8" >> /etc/resolv.conf`

### Sync does not work anymore

- read logs: `docker logs -f -n 10 [container id]`
- enter docker container: `docker exec -it [container id] /bin/sh`
- add nameserver: `echo "nameserver 8.8.8.8" >> /etc/resolv.conf`
