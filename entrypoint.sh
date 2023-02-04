#!/bin/sh

figlet "Ansible - $TAG" > /etc/motd

# generate host keys if not present
ssh-keygen -A

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e $@