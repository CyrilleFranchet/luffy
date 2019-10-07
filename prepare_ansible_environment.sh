#!/usr/bin/env bash

KEY_NAME="id_ed25519"
INVENTORY_FILENAME="production"
SERVER_PYTHON="python"

function usage() {
  cat <<EOF
usage: $0 [OPTIONS]
  Options:
    -i <ipaddress>    # IP address of the server
    -p <port>         # SSH port of the server
    -P <port>         # new SSH port to use on the server
    -u <username>     # Username used to connect to the server
    -U <username>     # Username to create on the server
    -b <path>         # Link to the Python binary (used on particular distributions)
    -h                # Show this help
EOF

  exit 0
}

function create_config() {
  cat << EOF > ansible.cfg
[defaults]
host_key_checking = False

[ssh_connection]
ssh_args = "-i ${KEY_NAME} -o IdentitiesOnly=yes"
EOF
}

function handle_ssh() {
  ssh-keygen -t ed25519 -f ${KEY_NAME} -C ansible-root
  ssh-copy-id -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -i ${KEY_NAME}.pub -p ${SERVER_PORT} ${SERVER_USER}@${SERVER_IP}
}

function create_inventory() {
  cat << EOF > ${INVENTORY_FILENAME}
luffy ansible_host=${SERVER_IP} ansible_port=${SERVER_PORT_SSH} ansible_user=${SERVER_USER_SSH} ansible_python_interpreter=${SERVER_PYTHON}
EOF
}

function create_var() {
  cat << EOF > host_vars/luffy
---
deployed_username: ${SERVER_USER_SSH}
deployed_key: "{{ lookup('file', '${KEY_NAME}.pub') }}"
deployed_port: ${SERVER_PORT_SSH}
EOF
}

unset SERVER_IP SERVER_USER SERVER_PORT SERVER_USER_SSH SERVER_PORT_SSH

while getopts ":i:u:U:p:b:P:h" o
do
  case "${o}" in
    i)
      SERVER_IP="${OPTARG}"
      ;;
    u)
      SERVER_USER="${OPTARG}"
      ;;
    U)
      SERVER_USER_SSH="${OPTARG}"
      ;;
    p)
      SERVER_PORT="${OPTARG}"
      ;;
    P)
      SERVER_PORT_SSH="${OPTARG}"
      ;;
    b)
      SERVER_PYTHON="${OPTARG}"
      ;;
    h)
      usage
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [[ -z ${SERVER_IP} || -z ${SERVER_USER} || -z ${SERVER_PORT} || -z ${SERVER_USER_SSH} || -z ${SERVER_PORT_SSH} ]]; then
    usage
fi

create_config
handle_ssh
create_inventory
create_var
