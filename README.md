# centos7

```
git clone git@github.com:joao-parana/centos7.git
cd centos7
./build-centos7
```

To run the container use:

```
docker run -d -e ROOT_PASSWORD=xyz  -p 22 parana/centos7 
```

or

```
docker run -i -t --rm -e ROOT_PASSWORD=xyz  -p 22 parana/centos7 bash
```

Please, view the comments on Dockerfile

