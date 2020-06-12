## To run container from CLI :

```
docker run -itd --cap-add=NET_ADMIN --cap-add=NET_RAW --cap-add=SYS_ADMIN -p80:8080 --name centos-shuttle thinakar/centos8:<version>
```