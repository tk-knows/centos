#!/usr/bin/expect

# disable timeout
set timeout -1

spawn sh -c {
  sshuttle -l 0.0.0.0 --ssh-cmd "ssh -o StrictHostKeyChecking=no" -N --dns -r virl@10.81.59.228 -D 172.16.1.0/24 -x 172.17.0.0/16
}

expect {
  *Are you sure you want to continue connecting (yes/no/* {
    send -- "yes\r"
  }
  *virl@10.81.59.228's password:* {
    send -- "VIRL\r"
  }
}

expect off
