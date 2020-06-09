#!/bin/bash
# credit: https://github.com/andrius/dockerfiles/tree/master/sshuttle

# Start the first process
sudo ./httpserver_start.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to run httpserver: $status"
  exit $status
fi

# Start the second process
sudo ./shuttle_start.sh -D
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to run shuttle_start.sh: $status"
  exit $status
fi


while sleep 60; do
  ps aux |grep apache_start |grep -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep shuttle_start |grep -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
     # if [ $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done

# /bin/bash -D

