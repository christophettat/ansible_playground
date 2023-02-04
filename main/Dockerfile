FROM alpine:3.14

RUN \
apk update && \
apk add --no-cache ansible && \
apk add openssh && \
apk add figlet && \
apk add sudo && \
ssh-keygen -A 

#RUN useradd --create-home --shell /bin/ash ansible && \
RUN addgroup -S ansible && adduser -D ansible -G ansible &&

RUN mkdir -p /home/ansible/.ssh
COPY ./ansible_keys/id_rsa /home/ansible/.ssh/id_rsa
COPY ./ansible_keys/id_rsa.pub /home/ansible/.ssh/id_rsa.pub
COPY ./ansible/inventory /home/ansible/inventory
COPY ./ansible/ansible.cfg /home/ansible/ansible.cfg
RUN echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /home/ansible/.ssh/config
RUN chown -R ansible:ansible /home/ansible

COPY ./main/sshd_config /etc/ssh/sshd_config


COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]