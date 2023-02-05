####################################################
# Server Side Up -  Docker Utility Image
#####################################################

FROM serversideup/docker-baseimage-s6-overlay-ubuntu:20.04

LABEL maintainer="Jay Rogers (@jaydrogers)"

# Make sure we keep apt silent during installs
ENV DEBIAN_FRONTEND=noninteractive \
    PUID=9999 \
    PGID=9999 \
    SSH_USER="tunnel" \
    SSH_GROUP="tunnelgroup" \
    SSH_USER_HOME="/home/tunnel" \
    SSH_PORT="2222" \
    SSH_HOST_KEY_DIR="/etc/ssh/ssh_host_keys" \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"

# Install SSH server and ping command
RUN apt-get update \
    && echo "Install requirements..." \
    && apt-get -y --no-install-recommends install \
        openssh-server \
        iputils-ping \
        locales \
        locales-all \
        otpw-bin \
        libpam-otpw \
    && echo "Create run directory..." \
    && mkdir /run/sshd \
    && echo "Configure our SSH user" \
    && groupadd -r -g $PGID $SSH_GROUP \
    && useradd --no-log-init -m -r -s /usr/bin/bash -d $SSH_USER_HOME -u $PUID -g $PGID $SSH_USER \
    && echo "Clean up after ourselves..." \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "Ensure generated keys are removed at this stage..." \
    && rm -rf /etc/ssh/ssh_host_*


RUN mkdir -p $SSH_USER_HOME/.ssh
RUN echo "$PRIVKEY" > $SSH_USER_HOME/.ssh/id_rsa
RUN echo -e "Host *\n\tStrictHostKeyCheckiZZng no\n" >> $SSH_USER_HOME/.ssh/config
RUN chown -R $SSH_USER:$SSH_GROUP $SSH_USER_HOME

# Copy over S6 configurations
COPY ./ExposedJumpHost/etc/cont-init.d/ /etc/cont-init.d/
COPY ./ExposedJumpHost/pam.d.sshd /etc/pam.d/ssh
#COPY ./ExposedJumpHost/sshd_config /etc/ssh/sshd_config

USER tunnel
RUN cd /home/tunnel && \
echo "rnd\nrnd" | otpw-gen > nothingtosee.txt	

USER root

#Expose the SSH port
EXPOSE 2222

#Configure S6 to drop priveleges
ENTRYPOINT ["/init"]

# -D in CMD below prevents sshd from becoming a daemon. -e is to log everything to stderr.
CMD ["/usr/sbin/sshd", "-D", "-e"]