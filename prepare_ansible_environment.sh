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
    -u <username>     # Username used to connect to the server
    -P <path>         # Link to the Python binary (used on particular distributions)
    -h                # Show this help
EOF

  exit 0
}

function handle_ssh() {
  ssh-keygen -t ed25519 -f ${KEY_NAME} -C ansible-root
  ssh-copy-id -o StrictHostKeyChecking=no -i ${KEY_NAME}.pub -p ${SERVER_PORT} ${SERVER_USER}@${SERVER_IP}
}

function create_inventory() {
  cat << EOF > ${INVENTORY_FILENAME}
luffy ansible_host=${SERVER_IP} ansible_port=${SERVER_PORT} ansible_user=${SERVER_USER} ansible_python_interpreter=${SERVER_PYTHON}
EOF
}

unset SERVER_IP SERVER_USER SERVER_PORT

while getopts ":i:u:p:P:h" o
do
  case "${o}" in
    i)
      SERVER_IP="${OPTARG}"
      ;;
    u)
      SERVER_USER="${OPTARG}"
      ;;
    p)
      SERVER_PORT="${OPTARG}"
      ;;
    P)
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

if [ -z "${SERVER_IP}" ] || [ -z "${SERVER_USER}" ] || [ -z "${SERVER_PORT}" ]; then
    usage
fi

handle_ssh
create_inventory
