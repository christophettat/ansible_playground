FROM alpine:3.14

RUN \
apk update && \
apk add --no-cache ansible && \
apk add openssh && \
apk add figlet && \
apk add sudo && \
ssh-keygen -A 

#RUN useradd --create-home --shell /bin/ash ansible && \
RUN addgroup -S ansible && adduser -D ansible -G ansible && \ 
echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 

RUN mkdir -p /home/ansible/.ssh
COPY ./ansible_keys/id_rsa /home/ansible/.ssh/id_rsa
COPY ./ansible_keys/id_rsa.pub /home/ansible/.ssh/id_rsa.pub
COPY ./ansible_keys/authorized_keys /home/ansible/.ssh/authorized_keys
RUN echo -e "Host *\n\tStrictHostKeyCheckiZZng no\n" >> /home/ansible/.ssh/config
RUN chown -R ansible:ansible /home/ansible


COPY ./sub/sshd_config /etc/ssh/sshd_config

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]