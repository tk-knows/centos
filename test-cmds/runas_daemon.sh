#!/bin/bash
# credit: https://github.com/andrius/dockerfiles/tree/master/sshuttle

# Start the first process
./httpserver_start.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to run httpserver: $status"
  exit $status
fi

sudo iptables --flush
# Start the second process
sshpass -p VIRL sshuttle -l 0.0.0.0 --ssh-cmd 'ssh -o StrictHostKeyChecking=no' -N --dns -r virl@10.81.59.228  172.16.1.0/24 -x 172.17.0.0/16 < /dev/null &

status=$?
if [ $status -ne 0 ]; then
  echo "Failed to run shuttle: $status"
  exit $status
fi


while sleep 60; do
  ps aux |grep http |grep -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep shuttle |grep -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
     # if [ $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    # exit 1
  fi
done

# /bin/bash -D

