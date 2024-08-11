# Running Kali linux on a docker container for macOS

## TODO
- make sure regular user has sudo
- install kali tools


## Prerequirement 
- XQuartz - make sure to go to settings -> security -> Allow connections from network clients. then run `xhost +localhost`. Then restart XQuartz.
- Docker for Mac - make sure to go to settings -> Features in development -> Enable host networking

## Build instructions
### Build image from scratch

```
cd kali-docker
cat <<'EOT'> .env
KALI_USERNAME=kali
KALI_PASS=toor
EOT

./kali-rebuild
```

### Launch container
`./kali-start`

### Pause container
`./kali-stop`
