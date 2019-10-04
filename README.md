# Introduction
This repo is used to deploy the streaming server.

# What to do at first
The only thing we need to do is to put the id_ed25519.pub in the /root/.ssh/authorized_keys of the streaming server.
The following command is used to generate the keys.

`ssh-keygen -t ed25519 -f id_ed25519 -C ansible-root -N --`

# Launch the installation process

