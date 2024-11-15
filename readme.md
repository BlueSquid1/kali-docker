# Running Kali linux on a docker container for macOS

## Description
This repo install kali linux and all the tools needed to do the OSCP exam.

## Prerequirement 
- XQuartz - make sure to go to settings -> security -> Allow connections from network clients. then run `xhost +localhost`. Then restart XQuartz.
- Docker for Mac

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

### Launch Kali Linux
`./kali-start`

### Pause Kali Linux
`./kali-stop`