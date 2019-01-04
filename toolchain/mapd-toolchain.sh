#!/usr/bin/env bash

set -e
set -x

PREFIX=$HOME/mapd-toolchain

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH

export CLANG=clang-4.0
export CLANGPP=clang++-4.0

# gcc-4.9
# g++-4.9
export CC=gcc-4.9
export CXX=g++-4.9

export TOOLCHAIN_LDFLAGS="-L$PREFIX/lib"
export TOOLCHAIN_CPPFLAGS="-I$PREFIX/include"

export GFLAGS_HOME=$PREFIX
export FLATBUFFERS_HOME=$PREFIX
export BOOST_ROOT=$PREFIX
export RAPIDJSON_HOME=$PREFIX

# Go
export PATH=$PATH:/usr/local/go/bin
export GOROOT=/usr/local/go

function install_conda_toolchain() {
  # conda create -y -p $PREFIX boost-cpp

  conda install -y -p $PREFIX \
        cmake \
        ccache \
        git \
        wget \
        curl \
        glog \
        gflags \
        jemalloc \
        libpq \
        lz4-c \
        boost-cpp \
        snappy \
        zlib \
        thrift-cpp=0.10.0 \
        blosc \
        curl \
        libarchive \
        libevent \
        ncurses \
        gdal \
        flatbuffers \
        rapidjson
}

# default-jre \
# default-jre-headless \
# default-jdk \
# default-jdk-headless \
# maven \
# clang \
# llvm \
# llvm-dev \

function install_system_dependencies() {
  sudo apt update
  sudo apt install -y \
      libldap2-dev \
      binutils-dev \
      google-perftools \
      libdouble-conversion-dev \
      libgoogle-perftools-dev \
      libiberty-dev \
      libglu1-mesa-dev \
      libglewmx-dev \
      liblzma-dev \
      libstdc++-4.9-dev
      autoconf \
      autoconf-archive \
      automake \
      bison \
      flex-old
}

function install_folly() {
  VERS=2017.10.16.00
  wget --continue https://github.com/facebook/folly/archive/v$VERS.tar.gz
  tar xvf v$VERS.tar.gz
  pushd folly-$VERS/folly
  /usr/bin/autoreconf -ivf
  LDFLAGS=$TOOLCHAIN_LDFLAGS CPPFLAGS=$TOOLCHAIN_CPPFLAGS \
         ./configure --prefix=$PREFIX --with-boost=$PREFIX \
         --with-openssl=$PREFIX
  make -j $(nproc)
  make install
  popd
}

function install_bisonpp() {
  VERS=1.21-45
  wget --continue https://github.com/jarro2783/bisonpp/archive/$VERS.tar.gz
  tar xvf $VERS.tar.gz
  pushd bisonpp-$VERS
  ./configure --prefix=$PREFIX
  make -j $(nproc)
  make install
  popd
}

function install_apache_arrow() {
  # VERS=ec32013fd6df35b051173f0e9aa8aa8833f1c819
  # wget --continue https://github.com/apache/arrow/archive/$VERS.tar.gz
  # tar -xf $VERS.tar.gz

  git clone http://github.com/apache/arrow.git arrow
  mkdir -p arrow/cpp/build
  pushd arrow/cpp/build

  cmake \
      -DCMAKE_BUILD_TYPE=debug \
      -DARROW_BUILD_SHARED=ON \
      -DARROW_BUILD_STATIC=ON \
      -DARROW_BUILD_TESTS=OFF \
      -DARROW_BUILD_BENCHMARKS=OFF \
      -DARROW_WITH_BROTLI=OFF \
      -DARROW_WITH_ZLIB=OFF \
      -DARROW_WITH_LZ4=OFF \
      -DARROW_WITH_SNAPPY=OFF \
      -DARROW_WITH_ZSTD=OFF \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DARROW_BOOST_USE_SHARED=off \
      -DARROW_GPU=ON \
      ..
  make -j $(nproc)
  make install
  popd
}

# install_conda_toolchain
# install_system_dependencies
install_bisonpp
# install_folly
# install_apache_arrow

CUDA_PATH=/usr/local/cuda-8.0
LLVM_PATH=/usr/lib/llvm-4.0

cat >> $PREFIX/mapd-deps.sh <<EOF
CUDA_PATH=$CUDA_PATH
LLVM_PATH=$LLVM_PATH
PREFIX=$PREFIX

CC=$CC
CXX=$CXX
GOROOT=$GOROOT

alias clang=$CLANG
alias clang++=$CLANGPP

LD_LIBRARY_PATH=\$CUDA_PATH/lib64:\$LD_LIBRARY_PATH
LD_LIBRARY_PATH=\$PREFIX/lib:\$PREFIX/lib64:\$LD_LIBRARY_PATH

PATH=\$LLVM_PATH/bin:\$PATH
PATH=\$CUDA_PATH/bin:\$PATH
PATH=\$PREFIX/bin:\$PATH
PATH=\$GOROOT/bin:\$PATH

export LD_LIBRARY_PATH PATH CC CXX GOROOT
EOF

echo
echo "Done. Be sure to source the 'mapd-deps.sh' file to pick up the required environment variables:"
echo "    source $PREFIX/mapd-deps.sh"
