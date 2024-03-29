#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

# Requirements
# - Ruby 2.x
# - Maven >= 3.3.9
# - GLib >= 2.52.2
# - JDK >=7
# - gcc >= 4.8

case $# in
  2) VERSION="$1"
     RC_NUMBER="$2"
     ;;

  *) echo "Usage: $0 X.Y.Z RC_NUMBER"
     exit 1
     ;;
esac

set -ex

HERE=$(cd `dirname "${BASH_SOURCE[0]:-$0}"` && pwd)

ARROW_DIST_URL='https://dist.apache.org/repos/dist/dev/arrow'

download_dist_file() {
  curl -f -O $ARROW_DIST_URL/$1
}

download_rc_file() {
  download_dist_file apache-arrow-${VERSION}-rc${RC_NUMBER}/$1
}

import_gpg_keys() {
  download_dist_file KEYS
  gpg --import KEYS
}

fetch_archive() {
  local dist_name=$1
  download_rc_file ${dist_name}.tar.gz
  download_rc_file ${dist_name}.tar.gz.asc
  download_rc_file ${dist_name}.tar.gz.md5
  download_rc_file ${dist_name}.tar.gz.sha512
  gpg --verify ${dist_name}.tar.gz.asc ${dist_name}.tar.gz
  gpg --print-md MD5 ${dist_name}.tar.gz | diff - ${dist_name}.tar.gz.md5
  sha512sum ${dist_name}.tar.gz | diff - ${dist_name}.tar.gz.sha512
}

setup_tempdir() {
  cleanup() {
    rm -fr "$TMPDIR"
  }
  trap cleanup EXIT
  TMPDIR=$(mktemp -d -t "$1.XXXXX")
}


setup_miniconda() {
  # Setup short-lived miniconda for Python and integration tests
  MINICONDA_URL=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh

  MINICONDA=`pwd`/test-miniconda

  wget -O miniconda.sh $MINICONDA_URL
  bash miniconda.sh -b -p $MINICONDA
  rm -f miniconda.sh

  export PATH=$MINICONDA/bin:$PATH

  conda create -n arrow-test -y -q python=3.6 \
        nomkl numpy pandas six cython
  source activate arrow-test
}

# Build and test C++

test_and_install_cpp() {
  mkdir cpp/build
  pushd cpp/build

  cmake .. -DCMAKE_INSTALL_PREFIX=$ARROW_HOME \
        -DARROW_GPU=on \
        -DARROW_PLASMA=on \
        -DARROW_PYTHON=on \
        -DCMAKE_BUILD_TYPE=release \
        -DARROW_BUILD_BENCHMARKS=on \
        ..

  make -j$NPROC
  make install

  ctest -L unittest
  popd
}

# Build and install Parquet master so we can test the Python bindings

install_parquet_cpp() {
  git clone git@github.com:apache/parquet-cpp.git

  mkdir parquet-cpp/build
  pushd parquet-cpp/build

  cmake .. -DCMAKE_INSTALL_PREFIX=$PARQUET_HOME \
        -DCMAKE_BUILD_TYPE=release \
        -DPARQUET_BUILD_TESTS=off \
        ..

  make -j4
  make install

  popd
}

# Build and test Python

test_python() {
  pushd python

  pip install -r requirements.txt

  python setup.py build_ext --inplace --with-parquet --with-plasma
  py.test pyarrow -v --pdb

  popd
}

# Build and test GLib, requires newer GLib (I used 2.52.3)

test_glib() {
  pushd c_glib

  ./configure --prefix=$ARROW_HOME
  make -j4
  make install

  NO_MAKE=yes test/run-test.sh

  popd
}

# Build and test Java (Requires newer Maven -- I used 3.3.9)

test_package_java() {
  pushd java

  mvn test
  mvn package

  popd
}

# Run integration tests
test_integration() {
  pushd integration

  JAVA_DIR=$SOURCE_DIR/java
  CPP_BUILD_DIR=$SOURCE_DIR/cpp/build

  export ARROW_JAVA_INTEGRATION_JAR=$JAVA_DIR/tools/target/arrow-tools-$VERSION-jar-with-dependencies.jar
  export ARROW_CPP_EXE_PATH=$CPP_BUILD_DIR/release

  python integration_test.py

  popd
}

setup_tempdir "arrow-$VERSION"
echo "Working in sandbox $TMPDIR"
cd $TMPDIR

export SOURCE_DIR=`pwd`
export ARROW_HOME=$TMPDIR/install
export PARQUET_HOME=$TMPDIR/install
export LD_LIBRARY_PATH=$ARROW_HOME/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$ARROW_HOME/lib/pkgconfig:$PKG_CONFIG_PATH

NPROC=$(nproc)
VERSION=$1
RC_NUMBER=$2

TARBALL=apache-arrow-$1.tar.gz

import_gpg_keys

DIST_NAME="apache-arrow-${VERSION}"
fetch_archive $DIST_NAME
tar xvzf ${DIST_NAME}.tar.gz
cd ${DIST_NAME}

setup_miniconda

test_and_install_cpp

install_parquet_cpp

test_python

test_glib

test_package_java

test_integration

echo 'Release candidate looks good!'
exit 0
