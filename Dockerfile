# We need to start from somewhere
FROM kalilinux/kali-rolling:latest
ARG USERNAME
ARG PASSWORD
ENV DEBIAN_FRONTEND noninteractive

# Bring everything up to date
RUN apt -y update && apt-get -y upgrade

# install common kali tools
RUN apt -y install kali-linux-default

RUN apt -y update

# install wordlists
RUN apt -y install seclists
RUN gzip -d /usr/share/wordlists/rockyou.txt.gz

# install systemd without graphics
RUN apt -y install systemd systemd-sysv
RUN systemctl set-default multi-user.target

# install firefox
RUN apt -y install firefox-esr 
# make firefox the developers edition
RUN wget -O /tmp/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
RUN tar -xjf /tmp/firefox.tar.bz2 -C /opt/

# install other useful tools
RUN apt -y install iputils-ping nano gobuster awscli mongodb-clients maven gitleaks htop
# wappalyzer + FoxyProxy firefox extensions?

# Clean up packages
RUN apt-get -y autoremove

# make a Kali user
RUN useradd -G sudo kali --shell /bin/bash --create-home
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd

# launch systemd when starting the container
ENTRYPOINT ["/lib/systemd/systemd"]