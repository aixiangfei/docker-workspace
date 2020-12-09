FROM debian:buster

ARG MYSQL_VERSION
ARG COMPOSER_VERSION
ARG NODE_VERSION
ARG DOCKER_VERSION
ARG DOCKER_COMPOSE_VERSION
ARG CTOP_VERSION

RUN if [ ! "$MYSQL_VERSION" ]; then echo "ARG MYSQL_VERSION is not set"; exit 1; fi
RUN if [ ! "${COMPOSER_VERSION}" ] ; then echo "ARG COMPOSER_VERSION is not set"; exit 1; fi
RUN if [ ! "${NODE_VERSION}" ] ; then echo "ARG NODE_VERSION is not set"; exit 1; fi
RUN if [ ! "${DOCKER_VERSION}" ] ; then echo "ARG DOCKER_VERSION is not set"; exit 1; fi
RUN if [ ! "${DOCKER_COMPOSE_VERSION}" ] ; then echo "ARG DOCKER_COMPOSE_VERSION is not set"; exit 1; fi
RUN if [ ! "${CTOP_VERSION}" ] ; then echo "ARG CTOP_VERSION is not set"; exit 1; fi

# 设置 bash
ADD .bashrc /root/.bashrc

# 常用工具
RUN apt update -y && \
    apt install -y \
        ca-certificates \
        inetutils-ping \
        netcat-openbsd \
        bash-completion \
        zip \
        tree \
        curl \
        ssh \
        git \
        vim \
        wget \
        net-tools \
        mycli \
        unzip \
        python3-pip \
        python3-venv \
        default-jdk

# 安装 mysql-server  https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/
ADD mysql_pubkey.asc /tmp/
RUN apt-key add /tmp/mysql_pubkey.asc
RUN echo "deb http://repo.mysql.com/apt/debian/ buster mysql-5.7" > /etc/apt/sources.list.d/mysql.list
RUN ["/bin/bash", "-c", "set -o pipefail && debconf-set-selections <<< 'mysql-community-server mysql-community-server/root-pass password 123456'"]
RUN ["/bin/bash", "-c", "set -o pipefail && debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password 123456'"]
RUN apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt -y install mysql-server

# php
RUN apt install -y \
    php-cli \
    php-curl \
    php-mbstring \
    php-mysql \
    php-pgsql \
    php-gd \
    php-zip \
    php-xml \
    php-pear \
    php-dev \
    php-xdebug

# 安装composer
RUN wget https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -O /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

# node
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash -
RUN apt-get install -y nodejs
RUN npm i redoc-cli -g -d

# 安装docker相关工具
RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz -O /tmp/docker.tgz
RUN tar zxvf /tmp/docker.tgz -C /tmp/
RUN cp /tmp/docker/docker /usr/local/bin/docker
RUN rm -rf /tmp/docker*
RUN chmod +x /usr/local/bin/docker

RUN wget https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 \
    -O /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN wget https://github.com/bcicen/ctop/releases/download/v${CTOP_VERSION}/ctop-${CTOP_VERSION}-linux-amd64 -O /usr/local/bin/ctop
RUN chmod +x /usr/local/bin/ctop

# 安装 sdkman
RUN curl -s get.sdkman.io | bash
# RUN sdk install springboot
# RUN echo -e "\nsource ~/.sdkman/candidates/springboot/current/shell-completion/bash/spring" >> /root/.bashrc

# 清除垃圾
RUN npm cache clean -f
RUN rm -rf /var/lib/apt/lists/* && apt -y autoremove && apt -y autoclean && apt -y clean

# 设置 bash
ADD .bashrc /root/.bashrc

# 设置 vim
RUN wget -O /root/.vimrc https://gist.githubusercontent.com/aixiangfei/1a66fabce654627fbd788bac65688054/raw/29617f6943289f86670fba19cce95269fc44d813/.vimrc

# 设置 git
RUN git config --global core.editor vim
RUN git config --global user.name 'aixiangfei'
RUN git config --global user.email "2792938834@qq.com"

RUN mkdir -p /root/.vscode-server/

WORKDIR /work/
