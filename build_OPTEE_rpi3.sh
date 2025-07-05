sudo apt install -y \
    android-tools-adb \
    android-tools-fastboot \
    autoconf \
    automake \
    bc \
    bison \
    build-essential \
    ccache \
    cpio \
    cscope \
    curl \
    device-tree-compiler \
    expect \
    flex \
    ftp-upload \
    gdisk \
    git \
    iasl \
    libattr1-dev \
    libcap-ng-dev \
    libfdt-dev \
    libftdi-dev \
    libglib2.0-dev \
    libgmp3-dev \
    libhidapi-dev \
    libmpc-dev \
    libncurses5-dev \
    libpixman-1-dev \
    libslirp-dev \
    libssl-dev \
    libtool \
    make \
    mtools \
    netcat \
    ninja-build \
    python-is-python3 \
    python3-crypto \
    python3-cryptography \
    python3-pip \
    python3-pyelftools \
    python3-serial \
    rsync \
    unzip \
    uuid-dev \
    wget \
    xdg-utils \
    xsltproc \
    xterm \
    xz-utils \
    zlib1g-dev
curl -o repo https://storage.googleapis.com/git-repo-downloads/repo
chmod a+x repo
sudo mv repo /bin/repo
mkdir OPTEE
cd OPTEE
repo init -u https://github.com/OP-TEE/manifest.git -m rpi3.xml  -b 3.4.0
#若遇到错误
cd .repo/repo && git checkout v1.13.9
cd ../../
repo init -u https://github.com/OP-TEE/manifest.git -m rpi3.xml  -b 3.4.0
repo sync -j10
#下面为正常执行
cd build
make toolchains
make all
#build optee_client
cd ../optee_client
make CROSS_COMPILE=aarch64-linux-gnu-
