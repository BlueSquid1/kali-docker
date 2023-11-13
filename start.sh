#Open Docker, only if is not running
if (! docker ps > /dev/null 2>&1 ); then
    # On Mac OS this would be the terminal command to launch Docker
    open /Applications/Docker.app
    #Wait until Docker daemon is running and has completed initialisation
    while (! docker stats --no-stream ); do
        # Docker takes a few seconds to initialize
        echo "Waiting for Docker to launch..."
        sleep 1
    done
fi

# common place to share files
mkdir -p /tmp/shared

# start x11 render and allow all traffic from localhost
xhost +localhost

# Check if container already exists
if (! docker container inspect kali-oscp > /dev/null 2>&1 ); then
    docker-compose up -d
fi
docker exec --user kali --workdir /home/kali -it kali-oscp /bin/bash