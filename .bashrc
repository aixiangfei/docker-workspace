LANG=C.UTF-8
PS1="\[\033[01;32m\][\u@docker-workspace\[\033[01;37m\] \w\[\033[01;32m\]]\$\[\033[00m\] "

function docker-clear() {
    docker stop $(docker ps -a | grep 'Exited' | awk '{print $1 }') //停止容器
    docker rm $(docker ps -a | grep 'Exited' | awk '{print $1 }') //删除容器
    docker rmi $(docker images | grep 'none' | awk '{print $3}') //删除镜像
}
