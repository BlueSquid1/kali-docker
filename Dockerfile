# We need to start from somewhere
FROM kalilinux/kali-rolling:latest
ENV DEBIAN_FRONTEND noninteractive

# Bring everything up to date
RUN apt -y update && apt-get -y upgrade

RUN apt -y install kali-linux-default

RUN apt -y update

RUN gzip -d /usr/share/wordlists/rockyou.txt.gz

RUN apt -y install iputils-ping

RUN apt -y install firefox-esr

# make it the developers edition
RUN wget -O /tmp/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
RUN tar -xjf /tmp/firefox.tar.bz2 -C /opt/
RUN rm -rf /tmp/firefox.tar.bz2

RUN apt -y install nano

RUN apt -y install gobuster

RUN apt -y install seclists

RUN apt -y install awscli

RUN apt -y install mongodb-clients

RUN apt -y install maven

RUN apt -y install gitleaks

RUN apt -y install htop

# Nessus? and wappalyzer + FoxyProxy firefox extensions?

# # Clean up packages
RUN apt-get -y autoremove

RUN useradd -G sudo kali --shell /bin/bash --create-home
RUN echo "kali:toor" | chpasswd

# Run Systemd
RUN cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*; \
  rm -f /lib/systemd/system/plymouth*; \
  rm -f /lib/systemd/system/systemd-update-utmp*;
RUN systemctl set-default multi-user.target
ENV init /lib/systemd/systemd
ENTRYPOINT ["/lib/systemd/systemd"]