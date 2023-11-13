if (! docker ps > /dev/null 2>&1 ); then
    echo "docker agent isn't running" >&2
    exit 1
fi

if (! docker container inspect kali-oscp > /dev/null 2>&1 ); then
    echo "kali-oscp container is not running" >&2
    exit 1
fi

docker stop kali-oscp