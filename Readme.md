## instructions to run shell file **_runas_daemon.sh_**

```
docker run -itd --cap-add=NET_ADMIN --cap-add=NET_RAW -p80:8080 --name centos-shuttle thinakar/centos8:v1.2
```