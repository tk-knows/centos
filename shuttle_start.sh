#!/usr/bin/expect

# disable timeout
set timeout -1

spawn sshuttle -l 0.0.0.0  -N --dns -r virl@10.81.59.228 -D 172.16.1.0/24 -x 172.17.0.0/16
expect "virl@10.81.59.228's password: "
send -- "VIRL\r"

expect off
