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
RUN apt -y install iputils-ping nano gobuster awscli mongodb-clients maven gitleaks htop burpsuite python3-venv gdb peass chisel ncat bloodhound golang-go freerdp3-x11 p7zip-full default-jdk gcc-x86-64-linux-gnu rlwrap

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
RUN useradd -G sudo kali --shell /usr/bin/bash --create-home
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd

# bug with m1 mac and XQuartz were java applications have a black screen: https://github.com/XQuartz/XQuartz/issues/31#issuecomment-2005961522
RUN echo "export _JAVA_OPTIONS='-Dsun.java2d.xrender=false'" >> /home/kali/.bashrc

# manual Install powershell because arm architecture isn't in apt-get :(
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell-7.4.2-linux-arm64.tar.gz -O /tmp/powershell-arm64.tar.gz
RUN mkdir /opt/powershell
RUN tar -xvf /tmp/powershell-arm64.tar.gz -C /opt/powershell
RUN echo "export PATH=/opt/powershell:$PATH" >> /home/kali/.bashrc

# SSH disabled rsa recently. re-enable it
RUN echo "HostKeyAlgorithms +ssh-rsa" >> /etc/ssh/ssh_config
RUN echo "MACs hmac-md5,hmac-sha1,umac-64@openssh.com" >> /etc/ssh/ssh_config

# install human readable names for SNMP instead of numeric object IDs
RUN apt -y install snmp-mibs-downloader
RUN download-mibs
RUN echo "" > /etc/snmp/snmp.conf

# xfreerdp will assume the X11 client is running linux. If you are using Apple as your host
# you will need to remap the key codes from from apple to linux. Usage:
# xfreerdp /v:<ip-address> $REMAP
RUN echo "export REMAP=/kbd:remap:8=30,remap:9=31,remap:10=32,remap:11=33,remap:12=35,remap:13=34,remap:14=44,remap:15=45,remap:16=46,remap:17=47,remap:19=48,remap:20=16,remap:21=17,remap:22=18,remap:23=19,remap:24=21,remap:25=20,remap:26=2,remap:27=3,remap:28=4,remap:29=5,remap:30=7,remap:31=6,remap:32=13,remap:33=10,remap:34=8,remap:35=12,remap:36=9,remap:37=11,remap:38=27,remap:39=24,remap:40=22,remap:41=26,remap:42=23,remap:43=25,remap:44=28,remap:45=38,remap:46=36,remap:47=40,remap:48=37,remap:49=39,remap:50=43,remap:51=51,remap:52=53,remap:53=49,remap:54=50,remap:55=52,remap:56=15,remap:57=57,remap:58=41,remap:59=14,remap:62=97,remap:63=125,remap:64=42,remap:65=58,remap:67=29,remap:68=54,remap:72=187,remap:80=115,remap:81=114,remap:82=113,remap:87=188,remap:88=189,remap:98=190,remap:104=63,remap:105=64,remap:106=65,remap:107=61,remap:108=66,remap:109=67,remap:111=87,remap:113=183,remap:114=186,remap:115=184,remap:117=68,remap:119=88,remap:121=185,remap:123=102,remap:124=104,remap:126=62,remap:127=107,remap:128=60,remap:129=109,remap:130=59,remap:131=105,remap:132=106,remap:133=108,remap:134=103" >> /home/kali/.bashrc

RUN echo "export PROMPT_COMMAND='history -a'"

COPY ./scripts/scanall /usr/local/bin/scanall
COPY ./scripts/credparser /usr/local/bin/credparser

# launch systemd when starting the container
ENTRYPOINT ["/lib/systemd/systemd"]