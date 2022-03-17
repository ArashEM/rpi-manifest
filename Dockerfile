FROM ubuntu:16.04

LABEL description="Yocto build environment"

# Enables us to overwrite the user and group ID for the yoctouser. See below
ARG userid=1001
ARG groupid=1001

USER root

# Install dependencies in one command to avoid potential use of previous cache
# like explained here: https://stackoverflow.com/a/37727984
RUN apt-get update && \
    apt-get install -y \
    gawk \
    wget \
    git-core \
    diffstat \
    unzip \
    texinfo \
    gcc-multilib \
    build-essential \
    chrpath \
    socat \
    cpio \
    python3 \
    python3-pip \
    python3-pexpect \
    xz-utils \
    debianutils \
    iputils-ping \
    python3-git \
    python3-jinja2 \
    libegl1-mesa \
    libsdl1.2-dev \
    pylint3 \
    xterm \
    vim \
    screen \
    tmux 

RUN apt-get clean
# Remove all apt lists to avoid build caching
RUN rm -rf /var/lib/apt/lists/*

# en_US.utf8 is required by Yocto sanity check
RUN /usr/sbin/locale-gen en_US.UTF-8
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN echo 'export LC_ALL="en_US.UTF-8"' >> /etc/profile
ENV LANG en_US.utf8

RUN useradd -U -m yocto

# Make sure the user/groupID matches the UID/GID given to Docker. This is so that mounted
# dirs will get the correct permissions
RUN usermod --uid $userid yoctouser
RUN groupmod --gid $groupid yoctouser
RUN echo 'yoctouser:yoctouser' | chpasswd
RUN echo 'yoctouser ALL=(ALL) NOPASSWD:SETENV: ALL' > /etc/sudoers.d/yoctouser

USER yocto
WORKDIR /home/yocto

