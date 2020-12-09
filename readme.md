# 基于Docker的工作环境

路径：

```
/work
  |- cache
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

登录阿里云镜像仓库： `docker login --username=2792938834@qq.com registry.cn-hangzhou.aliyuncs.com`

拉取镜像：
```shell
docker-compose pull
```
启动容器：
```shell
docker-compose up -d
```
