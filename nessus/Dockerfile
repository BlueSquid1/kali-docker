FROM tenable/nessus:latest-ubuntu
ARG USERNAME
ARG PASSWORD
ARG ACTIVATION_CODE

# rebuild the vulnerability database at build time instead of at runtime
ADD ./setup_nessus.sh /tmp/setup_nessus.sh
# Download plugins
RUN bash /tmp/setup_nessus.sh