# 基于Docker的工作环境

路径：

```
/work
  |- cache
  |- workspace
  |- projects
     |- projectA
        |- code1
        |- code2
        |- docker
           |- docker-compose.yaml
           |- docker-compose-dev.yaml

     |- projectB
       |- code1
       |- code2
       |- docker
         |- docker-compose.yaml
         |- docker-compose-dev.yaml
```
> 路径必须这样固定，才能使用 docker-in-docker（在 workspace 容器内部使用 docker client 来操控外部的
> docker-daemon，不然的话会出现容器内部路径与宿主机系统路径不一致的问题）

设置 letsencrypt 的权限：
```shell
$ chmod -R 600 letsencrypt
```

首先拉取镜像：
```shell
docker-compose pull
```
然后启动容器：
```shell
docker-compose up -d
```

