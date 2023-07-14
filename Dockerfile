FROM ubuntu:22.04 

USER root
WORKDIR /root

SHELL [ "/bin/bash", "-c" ]
# Existing lsb_release causes issues with modern installations of Python3
# https://github.com/pypa/pip/issues/4924#issuecomment-435825490
# Set (temporarily) DEBIAN_FRONTEND to avoid interacting with tzdata
ENV TZ=Asia/Ho_Chi_Minh \
    DEBIAN_FRONTEND=noninteractive

# Up2date system 
RUN apt-get update -y \
    && apt-get upgrade -y

# Install System tools
RUN apt-get -y install \
    sudo \
    wget \
    curl \
    gcc \
    make \
    tree \
    vim \
    vim-gtk3 \
    git \
    zsh \
    neofetch \
    dbus-x11

# Install Prerequisites packages 
RUN apt-get -y install \
    build-essential \
    checkinstall \
    libreadline-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev

# Install Python 
ARG PYTHON_VERSION_TAG=3.11.4
ARG LINK_PYTHON_TO_PYTHON3=https://www.python.org/ftp/python

RUN cd /opt \
    && wget ${LINK_PYTHON_TO_PYTHON3}/${PYTHON_VERSION_TAG}/Python-${PYTHON_VERSION_TAG}.tgz \
    && tar -xzf Python-${PYTHON_VERSION_TAG}.tgz \
    && cd Python-${PYTHON_VERSION_TAG} \
    && ./configure --enable-optimizations \
    && make altinstall \
    && rm /opt/Python-${PYTHON_VERSION_TAG}.tgz /opt/Python-${PYTHON_VERSION_TAG} -rf

# # Update the links to allow you to run python as opposed to specifying python3.11 when you want to run it.
RUN sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python3.11 1
RUN sudo update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.11 1

# Run GUI with Build-in Xserver on Windows 11
# https://www.youtube.com/watch?v=UEre6Bd75dw
# run docker as following
# docker run -it -v \\wsl.localhost\Ubuntu\mnt\wslg:/tmp my_ubuntu:v1.0 /bin/bash
ENV DISPLAY=:0

# Install ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Create user "docker" with sudo powers
ARG USERNAME=docker

RUN useradd -m $USERNAME && \
    usermod -aG sudo $USERNAME && \
    chsh -s /usr/bin/zsh $USERNAME && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cp /root/.bashrc /home/$USERNAME/ && \
    cp /root/.zshrc /home/$USERNAME/ && \
    cp -r /root/.oh-my-zsh /home/$USERNAME && \
    chown -R --from=root $USERNAME /home/$USERNAME

# Use C.UTF-8 locale to avoid issues with ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV USER $USERNAME
ENV HOME /home/$USERNAME
ENV PATH /home/$USERNAME/.local/bin:$PATH
USER $USERNAME
WORKDIR $HOME
# Avoid first use of sudo warning. c.f. https://askubuntu.com/a/22614/781671
RUN touch $HOME/.sudo_as_admin_successful



CMD ["/usr/bin/zsh"]