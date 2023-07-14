FROM alpine:3.18 

USER root
WORKDIR /root

SHELL [ "/bin/ash", "-c" ]
# Existing lsb_release causes issues with modern installations of Python3
# https://github.com/pypa/pip/issues/4924#issuecomment-435825490
# Set (temporarily) DEBIAN_FRONTEND to avoid interacting with tzdata
# ENV TZ=Asia/Ho_Chi_Minh \
#     DEBIAN_FRONTEND=noninteractive

RUN apk update \
    && apk upgrade

# Install zsh shell
RUN apk add \
    shadow \
    zsh \
    curl \
    git \
    sudo \
    wget \
    gcc \
    make \
    tree \
    vim \
    neofetch \
    tk-dev \
    libffi-dev \
    openssl-dev \
    musl-dev


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


RUN ln -sf /usr/local/bin/python3.11 /usr/bin/python
RUN ln -sf /usr/local/bin/pip3.11 /usr/bin/pip

# Install ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# change SHELL to /bin/zsh
SHELL [ "/bin/zsh", "-c" ]

CMD /bin/zsh