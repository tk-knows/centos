#!/bin/sh
# credit: https://github.com/andrius/dockerfiles/blob/master/sshuttle/docker-entrypoint.sh


onexit() {
  echo '=> Terminating process by signal (SIGINT, SIGTERM, SIGKILL, EXIT)'
  pkill -9 sshuttle ssh sshpass
  iptables --flush
  sleep 2
  iptables --flush
  sleep 1
  echo '=> Bye!'
  exit 0
}
trap onexit SIGINT SIGTERM SIGKILL EXIT

DOCKER_IP=`ip -o -f inet addr show | awk '/scope global/ {print $2,$4}' | awk '{print $2}'`
if [ "${DOCKER_IP}" != "" ]; then
  EXCLUDE_DOCKER_IP="-x ${DOCKER_IP}"
else
  EXCLUDE_DOCKER_IP=''
fi


mkdir -p /tmp/ssh

loopcnt=0
if [ "$1" = "" ]; then
  while [ $loopcnt -le 10 ]
  do
    echo "=> Setting up sshuttle connection to the ${SSH_USERNAME}@${SSH_HOST}:${SSH_PORT}"

    sshpass -p ${SSH_PASSWORD} \
      sshuttle --listen 0.0.0.0 --ssh-cmd "ssh -o StrictHostKeyChecking=no ${SSH_OPTIONS} " \
        --remote ${SSH_USERNAME}@${SSH_HOST}:${SSH_PORT} \
        ${SSHUTTLE_OPTIONS} ${SSHUTTLE_EXTRA_OPTIONS} \
        ${EXCLUDE_DOCKER_IP} \
        ${SSHUTTLE_NETWORKS}
    echo "=> SSH link down or sshuttle connection failed!"
    echo "=> Wait 5 seconds to reconnect"
    iptables --flush
    sleep 5
    iptables --flush
    echo "=> Reconnecting..."
    loopcnt=$(( $loopcnt + 1 ))
  done
else
  exec "$@"
fi
