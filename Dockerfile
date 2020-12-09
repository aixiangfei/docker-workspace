FROM debian:buster

ARG DOCKER_VERSION
ARG DOCKER_COMPOSE_VERSION
ARG CTOP_VERSION

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
        unzip \
        python3-pip \
        python3-venv

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

# 设置 vim
RUN git clone https://gist.github.com/1a66fabce654627fbd788bac65688054.git /opt/vimrc
RUN ln -sf /opt/vimrc/.vimrc /root/.vimrc

# 清除垃圾
RUN rm -rf /var/lib/apt/lists/* && apt -y autoremove && apt -y autoclean && apt -y clean

RUN mkdir -p /work/projects/
RUN mkdir -p /work/docker-apps/
WORKDIR /work/docker-apps/
