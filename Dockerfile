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

# update searchsploit database
RUN apt -y update && apt -y install exploitdb

# install systemd without graphics
RUN apt -y install systemd systemd-sysv
RUN systemctl set-default multi-user.target

# install other useful tools
RUN apt -y install iputils-ping nano gobuster awscli mongodb-clients maven gitleaks htop burpsuite python3.11-venv gdb peass chisel ncat bloodhound golang-go

# install kerbrute
RUN GOBIN=/usr/local/bin go install github.com/ropnop/kerbrute@latest

# install firefox
RUN apt -y install firefox-esr 
# make firefox the developers edition
RUN wget -O /tmp/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
RUN tar -xjf /tmp/firefox.tar.bz2 -C /opt/
# wappalyzer + FoxyProxy firefox extensions?

# Clean up packages
RUN apt-get -y autoremove

# make a Kali user
RUN useradd -G sudo kali --shell /usr/bin/zsh --create-home
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd

# bug with m1 mac and XQuartz were java applications have a black screen: https://github.com/XQuartz/XQuartz/issues/31#issuecomment-2005961522
RUN echo "export _JAVA_OPTIONS='-Dsun.java2d.xrender=false'" >> /home/kali/.zshrc

# manual Install powershell because arm architecture isn't in apt-get :(
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell-7.4.2-linux-arm64.tar.gz -O /tmp/powershell-arm64.tar.gz
RUN mkdir /opt/powershell
RUN tar -xvf /tmp/powershell-arm64.tar.gz -C /opt/powershell
RUN echo "export PATH=/opt/powershell:$PATH" >> /home/kali/.zshrc

# SSH disabled rsa recently. re-enable it
RUN echo "HostKeyAlgorithms +ssh-rsa" >> /etc/ssh/ssh_config
RUN echo "MACs hmac-md5,hmac-sha1,umac-64@openssh.com" >> /etc/ssh/ssh_config

# Start metasploit database service
RUN msfdb init

# launch systemd when starting the container
ENTRYPOINT ["/lib/systemd/systemd"]