# centos7

```
git clone git@github.com:joao-parana/centos7.git
cd centos7
./build-centos7
```

To run the container use:

```
docker run -d -e ROOT_PASSWORD=xyz --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 2222:22 -p 80:80 parana/centos7 
```

or

```
docker run -i -t --rm -e ROOT_PASSWORD=xyz --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 2222:22 -p 80:80 parana/centos7 bash
```

Is not possible run Docker in privileged mode sharing /sys/fs/cgroup in macOS or Windows 

For those systems use:

```
docker run -i -t --rm -e ROOT_PASSWORD=xyz  -p 2222:22 -p 80:80 parana/centos7 bash
```

Please, view the comments on Dockerfile

To view Default CentOS 7 Apache page use:

```
open http://$(docker-ip):80
```

![Default CentOS 7 Apache page](https://raw.githubusercontent.com/joao-parana/centos7/master/docs/images/centos7-apache.png)
