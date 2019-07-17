#!/usr/bin/env bash

set -ex

# For R stuff, follow https://cran.r-project.org/bin/linux/ubuntu/README.html

ARROW_DIR=$HOME/code/arrow

TOOLCHAIN_DIR=$HOME/code/dev-toolchain
MINICONDA=$HOME/miniconda
UBUNTU_SHORTNAME=$(lsb_release -cs)
RUBY_UBUNTU_VERSION=2.5

export PATH=$MINICONDA/bin:$PATH

function yubico_setup {
  sudo apt-get install -y wget
  wget https://github.com/Yubico/libu2f-host/blob/master/70-u2f.rules
  sudo mv 70-u2f.rules /etc/udev/rules.d/
}

# Dotfiles
function install_dotfiles() {
    mkdir -p $HOME/.config

    ln -sf $TOOLCHAIN_DIR/dotfiles/bash_personal ~/.bash_personal
    ln -sf $TOOLCHAIN_DIR/terminator ~/.config/terminator
    ln -sf $TOOLCHAIN_DIR/gitconfig ~/.gitconfig

BASHRC_ADDITION=$(cat <<-END
if [ -f ~/.bash_personal ]; then
    . ~/.bash_personal
fi
END
)
  echo "$BASHRC_ADDITION" >> ~/.bashrc
  echo "export EMACS_FONT=Terminus-14" >> ~/.bashrc
}

# Basic packages
function install_apt_packages() {
    sudo apt install -y \
         autoconf-archive \
         gtk-doc-tools \
         libgirepository1.0-dev \
         xfonts-terminus \
         gnome-tweak-tool \
         gnome-session-flashback \
         pandoc \
         ccache \
         terminator \
         xsel \
         libssl-dev \
         valgrind \
         jq \
         gdb \
         bison \
         flex \
         pkg-config \
         autoconf \
         automake \
         libtool \
         subversion \
         cloc \
         filezilla \
         bcrypt \
         libcurl4-openssl-dev

    LLVM_VERSION=7

    sudo apt-get install -y \
         libllvm$LLVM_VERSION \
         llvm-$LLVM_VERSION-dev \
         clang-$LLVM_VERSION \
         clang-format-$LLVM_VERSION \
         clang-tidy-$LLVM_VERSION \
         libfuzzer-$LLVM_VERSION-dev
}

function install_apt_packages_1404() {
    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
    sudo apt-add-repository -y "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty main"
    sudo apt-add-repository -y "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-6.0 main"
    sudo apt update
    install_apt_packages
}

function install_apt_packages_1804() {
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
    sudo apt-add-repository -y "deb http://apt.llvm.org/$UBUNTU_SHORTNAME/ llvm-toolchain-$UBUNTU_SHORTNAME main"
    sudo apt update
    install_apt_packages

    sudo apt install -y \
         redshift \
         redshift-gtk
}


# Miniconda
function install_conda() {
    MINICONDA_URL="https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    wget -O miniconda.sh $MINICONDA_URL
    bash miniconda.sh -b -p $MINICONDA
    rm -f miniconda.sh
    export PATH="$MINICONDA/bin:$PATH"

    conda update -y -q conda
    conda config --set auto_update_conda false
    conda info -a

    conda config --set show_channel_urls True
    conda config --add channels https://repo.continuum.io/pkgs/free
    conda config --add channels conda-forge
}

# C++ toolchain
function install_cpp_toolchain() {
    conda create -yq -p $HOME/cpp-toolchain \
	  --file=$ARROW_DIR/ci/conda_env_cpp.yml \
	  --file=$ARROW_DIR/ci/conda_env_gandiva.yml \
          -c conda-forge
}

function install_cpp_runtime_toolchain() {
    conda create -yq -p $HOME/cpp-runtime-toolchain \
          boost-cpp \
          c-ares \
          grpc-cpp \
          gflags \
          glog \
          libprotobuf \
          zstd \
          lz4-c \
          bzip2 \
          zlib \
	  re2 \
          snappy \
          thrift-cpp \
          -c conda-forge
}

# Install conda environments
function create_conda_dev_environments() {
    conda create -yq -n arrow-3.7 \
          python=3.7
    conda create -yq -n arrow-2.7 \
          python=2.7
}

function install_conda_dev_environments() {
    ARROW_CONDA_DEPS="\
          pytest \
          flake8 \
          cmake \
          git \
          requests \
          jira \
          ninja \
          ipython \
          jupyter \
          setuptools_scm \
          matplotlib"

    conda install -yq -n arrow-3.7 \
	  --file=$ARROW_DIR/ci/conda_env_python.yml \
          $ARROW_CONDA_DEPS
    conda install -yq -n arrow-2.7 \
	  --file=$ARROW_DIR/ci/conda_env_python.yml \
          $ARROW_CONDA_DEPS

    conda activate arrow-3.7
    pip install cmake_format==0.5.2
    conda deactivate
}

function install_emacs() {
    rm -rf $HOME/.emacs.d
    ln -sf $TOOLCHAIN_DIR/emacs $HOME/.emacs.d
}

# Install Ruby
function install_ruby_source() {
    sudo apt-get build-dep -y ruby$RUBY_UBUNTU_VERSION
    RUBY_VERSION=2.5.0
    wget -O ruby.tar.gz https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.0.tar.gz
    tar xvf ruby.tar.gz
    pushd ruby-$RUBY_VERSION
    CC=gcc ./configure --prefix=$HOME/ruby
    CC=gcc make -j8
    make install
    popd
    rm -rf ruby-$RUBY_VERSION
    rm -rf ruby.tar.gz
}

function install_ruby() {
    sudo apt-get install -y ruby-dev
}

# Setup Docker
function setup_docker() {
    sudo apt-get -y install \
         apt-transport-https \
         ca-certificates \
         curl \
         software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
         $(lsb_release -cs) \
         stable"

    sudo apt-get update
    sudo apt install docker-ce

    sudo usermod -aG docker $USER
}

function install_docker() {
    sudo apt-get -y install \
         apt-transport-https \
         ca-certificates \
         curl \
         software-properties-common
    sudo apt install -y docker.io

    sudo usermod -aG docker $USER

    # install docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose
}

# Golang

function install_go() {
    local OS=linux
    local ARCH=amd64
    local VERSION=1.12.7

    local GO_ARCHIVE=go$VERSION.$OS-$ARCH.tar.gz
    wget https://dl.google.com/go/$GO_ARCHIVE
    sudo tar -xzf $GO_ARCHIVE

    # idempotence
    sudo rm -rf /opt/go$VERSION
    sudo mv go/ /opt/go$VERSION

    rm -f $GO_ARCHIVE

BASHRC_ADDITION=$(cat <<-END
export GOROOT=/opt/go$VERSION
export GOPATH=\$HOME/go
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
END
)
  echo "$BASHRC_ADDITION" >> ~/.bashrc
}

# Ocaml

# Spotify
function install_spotify() {
  # 1. Add the Spotify repository signing keys to be able to verify downloaded packages
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90

  # 2. Add the Spotify repository
  echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

  # 3. Update list of available packages
  sudo apt-get update

  # 4. Install Spotify
  sudo apt-get install -y spotify-client
}

# Install cuda
# https://askubuntu.com/questions/799184/how-can-i-install-cuda-on-ubuntu-16-04
# Check the md5 sum: md5sum cuda_7.5.18_linux.run. Only continue if it is correct.

# Remove any other installation (sudo apt-get purge nvidia-cuda* - if you want to
# install the drivers too, then sudo apt-get purge nvidia-*.)
# If you want to install the display drivers(*), logout from your GUI. Go to a
# terminal session (ctrl+alt+F2)
# Stop lightdm: sudo service lightdm stop

# Create a file at /etc/modprobe.d/blacklist-nouveau.conf with the following
# contents:

# blacklist nouveau
# options nouveau modeset=0
#
# Then do: sudo update-initramfs -u

# sudo sh cuda_7.5.18_linux.run --override.

# Make sure that you say y for the symbolic link.
# Start lightdm again: sudo service lightdm start

function install_cuda() {
    sudo add-apt-repository -y ppa:graphics-drivers
    sudo apt-get update
    sudo apt-get install nvidia-390
}


function install_hugo() {
    go get github.com/magefile/mage
    go get -d github.com/gohugoio/hugo
    cd ${GOPATH:-$HOME/go}/src/github.com/gohugoio/hugo
    go install
}

# FIRST TIME? Make sure to uncomment all the deb-src entries in /etc/apt/sources.list

if [ ! -d "$ARROW_DIR" ]; then
   git clone https://github.com/wesm/arrow.git $ARROW_DIR
fi

# install_apt_packages_1804
# install_docker

# install_conda
# create_conda_dev_environments
# install_conda_dev_environments
# install_cuda
# install_ruby
# install_dotfiles
# install_spotify
# install_cpp_toolchain
# install_cpp_runtime_toolchain
# install_emacs

# install_go
# install_hugo
