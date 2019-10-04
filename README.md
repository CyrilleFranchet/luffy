# Introduction
This repo is used to deploy the streaming server.

# What to do at first
Launch the Bash script to generate and install SSH keys on the target and prepare the Ansible inventory file accordingly.
The script **prepare_ansible_environment.sh** requires some arguments.

  usage: ./prepare_ansible_environment.sh [OPTIONS]
    Options:
      -i <ipaddress>    # IP address of the server
      -p <port>         # SSH port of the server
      -u <username>     # Username used to connect to the server
      -P <path>         # Link to the Python binary (used on particular distributions)
      -h                # Show this help

We need to:
  - provide the IP address of our target
  - provide the SSH port used to connect to
  - provide the username used to login
  - provide the full path to the Python3 binary (optional)

# Launch the installation process

