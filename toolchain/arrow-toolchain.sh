#!/usr/bin/env bash

export ARROW_CLANG_VERSION=7
export ARROW_GCC=gcc
export ARROW_GXX=g++
export ARROW_LLVM_VERSION=$ARROW_CLANG_VERSION

# export CXX_ABI_OPTION='-D_GLIBCXX_USE_CXX11_ABI=0'
export CXX_ABI_OPTION=

export ARROW_USE_SHARED_BOOST=ON
export ARROW_ERROR_CONTEXT=ON
export ARROW_WITH_FUZZING=OFF
export ARROW_BUILD_BENCHMARKS=ON
export ARROW_BUILD_TESTS=ON
export ARROW_BUILD_BZ2=ON
export ARROW_BUILD_HIVESERVER2=OFF
export ARROW_BUILD_ZSTD=ON
export ARROW_BUILD_ORC=OFF
export ARROW_BUILD_PARQUET=ON
export ARROW_BUILD_PLASMA=ON
export ARROW_BUILD_PYTHON=ON
export ARROW_GANDIVA_BUILD_TESTS=ON
export ARROW_BUILD_FLIGHT=ON
export ARROW_GFLAGS_USE_SHARED=OFF
export ARROW_GTEST_VENDORED=ON
export ARROW_BUILD_GANDIVA=OFF
export ARROW_BUILD_GANDIVA_JNI=OFF
export ARROW_USE_CCACHE=ON
export ARROW_USE_JEMALLOC=ON
export ARROW_USE_GLOG=OFF
export ARROW_USE_LD_GOLD=ON
export ARROW_USE_VALGRIND=OFF
export ARROW_OPTIONAL_INSTALL=ON

export ARROW_BUILD_GPU=$ARROW_LOCAL_BUILD_CUDA
export PYARROW_WITH_CUDA=$ARROW_LOCAL_BUILD_CUDA

export PYARROW_WITH_FLIGHT=1
export PYARROW_WITH_ORC=0
export PYARROW_WITH_PARQUET=1
export PYARROW_WITH_PLASMA=1
export PYARROW_WITH_GANDIVA=0

export PYARROW_BUNDLE_ARROW_CPP=0
export PYARROW_BUNDLE_BOOST=0
export PYARROW_PARALLEL=$(nproc)
export PYARROW_CMAKE_GENERATOR=Ninja

export XCODE_ROOT=/Applications/Xcode.app/Contents/Developer
export DEVELOPER_DIR=$XCODE_ROOT

# export USE_NINJA_BUILD=
export USE_NINJA_BUILD=-GNinja

export ARROW_ROOT=$HOME/code/arrow
export ARROW_TEST_DATA=$ARROW_ROOT/testing/data
export PARQUET_TEST_DATA=$ARROW_ROOT/cpp/submodules/parquet-testing/data

function use_gcc8 {
    export CC=gcc-8
    export CXX=g++-8
}

function use_gcc {
    export CC=gcc
    export CXX=g++
}

function osx_toolchain {
    export MACOSX_DEPLOYMENT_TARGET=10.9
    export CC=$XCODE_ROOT/usr/bin/gcc
    export CXX=$XCODE_ROOT/usr/bin/g++
    export CONDA_ENV_PATH=/Users/wesm/anaconda/envs/arrow-test
}

function linux_toolchain {
  export CC=clang-$ARROW_CLANG_VERSION
  export CXX=clang++-$ARROW_CLANG_VERSION
  export CPP_TOOLCHAIN=$HOME/cpp-toolchain
  export CPP_RUNTIME_TOOLCHAIN=$HOME/cpp-runtime-toolchain
}

function xcode64 {
    export XCODE_ROOT=/Applications/Xcode-6.app/Contents/Developer
    export DEVELOPER_DIR=$XCODE_ROOT
    osx_toolchain
}

function system_toolchain {
  if [[ $OSTYPE == "darwin"* ]]; then
      osx_toolchain
  else
      linux_toolchain
  fi
}

system_toolchain

export ARROW_BUILD_TENSORFLOW=OFF

export ASAN_SYMBOLIZER_PATH=$(type -p llvm-symbolizer)

export TOOLCHAIN_CUDA_VERSION=10.1

DEBUG_TP_DIR=$HOME/local
RELEASE_TP_DIR=$HOME/local-release

export TP_DIR=$DEBUG_TP_DIR
export TOOLCHAIN_BUILD_TYPE=debug

export LD_LIBRARY_PATH_BAK=${LD_LIBRARY_PATH_BAK:=$LD_LIBRARY_PATH}
export PATH_BAK=$PATH

export ARROW_LIBHDFS3_DIR=$HOME/anaconda3/lib

export CUDA_HOME=/usr/local/cuda-${TOOLCHAIN_CUDA_VERSION}
export CUDA_TOOLKIT_ROOT_DIR=${CUDA_HOME}
export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
export PATH=${CUDA_HOME}/bin:${PATH}

# Use local ruby
export PATH=$HOME/ruby/bin:$PATH

function set_build_env() {
    echo "Thirdparty dir: $TP_DIR"
    export ARROW_BOOST_ROOT=$CPP_TOOLCHAIN

    export ARROW_R_DEV=TRUE

    export BOOST_ROOT=$CPP_TOOLCHAIN

    # libprotobuf used by Orc EP build
    export PROTOBUF_HOME=$CPP_TOOLCHAIN

    export ARROW_BOOST_ROOT=$CPP_TOOLCHAIN

    export ARROW_HOME=$TP_DIR
    export PARQUET_HOME=$TP_DIR

    export PATH=$CPP_TOOLCHAIN/bin:$PATH_BAK
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH_BAK:$TP_DIR/lib
    export LD_LIBRARY_PATH=$CPP_RUNTIME_TOOLCHAIN/lib:$LD_LIBRARY_PATH

    export R_LD_LIBRARY_PATH=$LD_LIBRARY_PATH

    # export GTEST_HOME=$CPP_TOOLCHAIN

    export PKG_CONFIG_PATH=$TP_DIR/lib/pkgconfig:$CPP_TOOLCHAIN/lib/pkgconfig

    export PYARROW_BUILD_TYPE=$TOOLCHAIN_BUILD_TYPE

    # export CXXFLAGS="-Werror -Wall -fno-omit-frame-pointer"

    export ARROW_INSTALL_DIR=$TP_DIR

# -DCMAKE_CXX_FLAGS='-D_GLIBCXX_USE_CXX11_ABI=0' \

    export ARROW_BUILD_TOOLCHAIN=$CPP_TOOLCHAIN

export ARROW_GCC_OPTIONS="\
$USE_NINJA_BUILD \
-DARROW_DEPENDENCY_SOURCE=SYSTEM \
-DARROW_PACKAGE_PREFIX=$CPP_TOOLCHAIN \
-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
-DCMAKE_INSTALL_PREFIX=$ARROW_INSTALL_DIR \
-DCMAKE_BUILD_TYPE=$TOOLCHAIN_BUILD_TYPE \
-DCMAKE_PREFIX_PATH=$TP_DIR \
-DARROW_OPTIONAL_INSTALL=$ARROW_OPTIONAL_INSTALL \
-DARROW_VERBOSE_THIRDPARTY_BUILD=off \
-DARROW_NO_DEPRECATED_API=on \
-DARROW_EXTRA_ERROR_CONTEXT=on \
-DARROW_BOOST_USE_SHARED=$ARROW_USE_SHARED_BOOST \
-DARROW_WITH_BZ2=$ARROW_BUILD_BZ2 \
-DARROW_WITH_ZSTD=$ARROW_BUILD_ZSTD \
-DARROW_BUILD_BENCHMARKS=$ARROW_BUILD_BENCHMARKS \
-DARROW_BUILD_TESTS=$ARROW_BUILD_TESTS \
-DARROW_FLIGHT=$ARROW_BUILD_FLIGHT \
-DARROW_GANDIVA=$ARROW_BUILD_GANDIVA \
-DARROW_GANDIVA_JAVA=$ARROW_BUILD_GANDIVA_JNI \
-DARROW_GANDIVA_STATIC_LIBSTDCPP=OFF \
-DARROW_HDFS=on \
-DARROW_HIVESERVER2=$ARROW_BUILD_HIVESERVER2 \
-DARROW_USE_CCACHE=$ARROW_USE_CCACHE \
-DARROW_USE_GLOG=$ARROW_USE_GLOG \
-DARROW_USE_LD_GOLD=$ARROW_USE_LD_GOLD \
-DARROW_JEMALLOC=$ARROW_USE_JEMALLOC \
-DARROW_ORC=$ARROW_BUILD_ORC \
-DARROW_PARQUET=$ARROW_BUILD_PARQUET \
-DPYTHON_EXECUTABLE=$CONDA_PREFIX/bin/python \
-DPARQUET_BUILD_EXECUTABLES=on \
-DPARQUET_BUILD_EXAMPLES=on \
-DARROW_PYTHON=$ARROW_BUILD_PYTHON \
-DARROW_CUDA=$ARROW_BUILD_GPU \
-DBOOST_ROOT=$ARROW_BOOST_ROOT \
-Duriparser_SOURCE=BUNDLED \
$EXTRA_ARROW_FLAGS"

export PYARROW_CXXFLAGS="$CXX_ABI_OPTION"
    echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
    echo "R_LD_LIBRARY_PATH: $R_LD_LIBRARY_PATH"
    echo "CC: $CC"
    echo "CXX: $CXX"
    echo "ARROW_CXXFLAGS: $ARROW_CXXFLAGS"
    echo "ARROW_R_CXXFLAGS: $ARROW_R_CXXFLAGS"
    echo "ARROW_OPTIONS: $ARROW_GCC_OPTIONS"
    echo "PYARROW_CXXFLAGS: $ARROW_CXXFLAGS"
}

function debug() {
  export TP_DIR=$DEBUG_TP_DIR
  export TOOLCHAIN_BUILD_TYPE=debug

  export EXTRA_ARROW_FLAGS="\
$ARROW_TOOLCHAIN_FLAGS
-DBUILD_WARNING_LEVEL=CHECKIN"

  export ARROW_CXXFLAGS="-fno-omit-frame-pointer"
  export ARROW_R_CXXFLAGS="-fno-omit-frame-pointer"

  # ASAN for R
  export ARROW_R_CXXFLAGS="$ARROW_R_CXXFLAGS -fsanitize=address -DADDRESS_SANITIZER"

  # UBSAN for R
  export ARROW_R_CXXFLAGS="$ARROW_R_CXXFLAGS -fsanitize=undefined -fno-sanitize=alignment,vptr,function -fno-sanitize-recover=all"

  export USE_ASAN=OFF
  export USE_UBSAN=OFF

  set_build_env
}

function release() {
  export TP_DIR=$RELEASE_TP_DIR
  export TOOLCHAIN_BUILD_TYPE=release

  export USE_ASAN=OFF
  export USE_UBSAN=OFF

  export ARROW_CXXFLAGS='-fno-omit-frame-pointer'
  export ARROW_CXXFLAGS=""
  export EXTRA_ARROW_FLAGS="" # -DBUILD_WARNING_LEVEL=CHECKIN"

  set_build_env
}

function set_build_type_flags() {
    if [ $TOOLCHAIN_BUILD_TYPE = "release" ]; then
        release
    else
        debug
    fi
}

function toolchain_clang {
    # export CC=$CLANG_TOOLS_PATH/clang
    # export CXX=$CLANG_TOOLS_PATH/clang++
    # export CC=clang-$ARROW_CLANG_VERSION
    # export CXX=clang++-$ARROW_CLANG_VERSION

  export ARROW_TOOLCHAIN_FLAGS="\
-DARROW_FUZZING=$ARROW_WITH_FUZZING \
-DARROW_TEST_MEMCHECK=$ARROW_USE_VALGRIND \
-DARROW_USE_ASAN=$USE_ASAN \
-DARROW_USE_UBSAN=$USE_UBSAN"

  set_build_type_flags
}

function toolchain_gcc {
    export CC=$ARROW_GCC
    export CXX=$ARROW_GXX

    export ARROW_TOOLCHAIN_FLAGS="\
-DARROW_FUZZING=OFF \
-DARROW_TEST_MEMCHECK=$ARROW_USE_VALGRIND \
-DARROW_USE_ASAN=$USE_ASAN \
-DARROW_USE_UBSAN=$USE_UBSAN"

  set_build_type_flags
}

toolchain_clang

export PATH=$CPP_TOOLCHAIN/bin:$PATH

# export TERM=xterm-color

# Using Impala's thirdparty bits. Looking at output of impala-config.sh
export JAVA_HOME=/usr/lib/jvm/java-8-oracle

export HADOOP_HOME=/usr/local/hadoop
export ARROW_HDFS_TEST_HOST=localhost
export ARROW_HDFS_TEST_USER=root
export ARROW_HDFS_TEST_PORT=9000

# export HADOOP_HOME=/home/wesm/code/cloudera/impala/thirdparty/hadoop-2.6.0-cdh5.7.0
# export HADOOP_HOME=/home/wesm/code/cloudera/impala/thirdparty/hadoop-2.6.0-cdh5.7.0-SNAPSHOT

# if [ ! -d "$HADOOP_HOME" ]; then
#     export HADOOP_HOME=/home/wesm/code/cloudera/impala/thirdparty/hadoop-2.6.0-cdh5.8.0-SNAPSHOT
# fi

# This avoids native-hadoop loading error / warning =( =(
if [ -d "$HADOOP_HOME" ]; then
    export CLASSPATH=`$HADOOP_HOME/bin/hadoop classpath --glob`
    export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib/native"
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native/
fi

export ARROW_HDFS_TEST_HOST=localhost
export ARROW_HDFS_TEST_PORT=20500
export ARROW_HDFS_TEST_USER=wesm

function arrow_cpp_update {
    _PYTHON_VERSION=$(python -c "import sys; print('{0}.{1}'.format(sys.version_info.major, sys.version_info.minor))")
    _BUILD_DIR=$ARROW_ROOT/cpp/library-build-$TOOLCHAIN_BUILD_TYPE-$_PYTHON_VERSION
    mkdir -p $_BUILD_DIR
    pushd $_BUILD_DIR
    cmake -GNinja \
          -DARROW_DEPENDENCY_SOURCE=SYSTEM \
          -DARROW_PACKAGE_PREFIX=$CPP_TOOLCHAIN \
          -DCMAKE_INSTALL_PREFIX=$TP_DIR \
          -DCMAKE_BUILD_TYPE=$TOOLCHAIN_BUILD_TYPE \
          -DCMAKE_CXX_FLAGS=$CXX_ABI_OPTION \
          -DARROW_CXXFLAGS=$ARROW_CXXFLAGS \
          -DARROW_EXTRA_ERROR_CONTEXT=$ARROW_ERROR_CONTEXT \
          -DARROW_NO_DEPRECATED_API=OFF \
          -DARROW_BOOST_USE_SHARED=$ARROW_USE_SHARED_BOOST \
          -DARROW_BUILD_BENCHMARKS=off \
          -DARROW_BUILD_UTILITIES=off \
          -DARROW_JEMALLOC=$ARROW_USE_JEMALLOC \
          -DARROW_CUDA=$ARROW_BUILD_GPU \
          -DARROW_FLIGHT=$ARROW_BUILD_FLIGHT \
          -DARROW_GANDIVA=$ARROW_BUILD_GANDIVA \
          -DARROW_GFLAGS_USE_SHARED=$ARROW_GFLAGS_USE_SHARED \
          -DARROW_ORC=$ARROW_BUILD_ORC \
          -DARROW_PARQUET=$ARROW_BUILD_PARQUET \
          -DARROW_PLASMA=$ARROW_BUILD_PLASMA \
          -DARROW_PYTHON=on \
          -DARROW_TENSORFLOW=$ARROW_BUILD_TENSORFLOW \
          -DARROW_WITH_BZ2=$ARROW_BUILD_BZ2 \
          -DARROW_WITH_ZSTD=$ARROW_BUILD_ZSTD \
          -DARROW_BUILD_TESTS=off \
          -DARROW_USE_ASAN=$USE_ASAN \
          -DARROW_USE_UBSAN=$USE_UBSAN \
          -DARROW_USE_GLOG=$ARROW_USE_GLOG \
          -DCMAKE_BUILD_TYPE=$TOOLCHAIN_BUILD_TYPE \
          -Duriparser_SOURCE=BUNDLED \
          ..
    ninja
    ninja install
    popd
}

function arrow_cmake {
    cmake $ARROW_GCC_OPTIONS \
          -DARROW_PLASMA=on \
          -DARROW_CXXFLAGS="$ARROW_CXXFLAGS" \
          -DCMAKE_BUILD_TYPE=$TOOLCHAIN_BUILD_TYPE ..
}

function arrow_gcc {
    toolchain_gcc
    arrow_cmake
}

function arrow_clang {
    toolchain_clang
    arrow_cmake
}

function build_pyarrow {
    python setup.py build_ext --inplace
}

function arrow_glib_test {
    # arrow_cpp_update
    pushd $ARROW_ROOT/c_glib
    git clean -fdx .
    export PKG_CONFIG_PATH=$TP_DIR/lib/pkgconfig:$PKG_CONFIG_PATH
    export GI_TYPELIB_PATH=$TP_DIR/lib/girepository-1.0
    GLIB_CXXFLAGS="$CXX_ABI_OPTION -ggdb -O0"
    ./autogen.sh
    ./configure CXXFLAGS="$GLIB_CXXFLAGS" CFLAGS="$GLIB_CXXFLAGS" \
                --prefix=$TP_DIR --enable-gtk-doc
    CXXFLAGS=$GLIB_CXXFLAGS CFLAGS=$GLIB_CXXFLAGS make -j8
    make install

    export GI_TYPELIB_PATH=$TP_DIR/lib/girepository-1.0
    NO_MAKE=yes test/run-test.sh

    popd
}

function arrow_preflight {
    ARROW_PREFLIGHT_DIR=$ARROW_ROOT/cpp/preflight-build
    mkdir -p $ARROW_PREFLIGHT_DIR
    pushd $ARROW_ROOT/cpp
    python build-support/lint_cpp_cli.py src || return

    pushd apidoc
    doxygen || return
    popd

    popd
    pushd $ARROW_PREFLIGHT_DIR
    arrow_cmake
    ninja format
    ninja lint || return
    popd
    pushd $ARROW_ROOT
    ./run-cmake-format.py
    popd
    flake8 $ARROW_ROOT/dev || return
    pushd $ARROW_ROOT/python
    flake8 --count pyarrow || return
    flake8 --count --config=.flake8.cython pyarrow || return
    popd
}

function get_arrow_sha256 {
    TMPNAME=`uuidgen`.tar.gz
    wget https://github.com/apache/arrow/archive/$1.tar.gz -O $TMPNAME
    echo `sha256sum $TMPNAME`
    rm -rf $TMPNAME
}

function update_tp_toolchain {
    ccache -C
    arrow_cpp_update
}

function update_pyarrow {
    update_tp_toolchain
    pushd $ARROW_ROOT/python
    rm -rf build/
    python setup.py build_ext --inplace
    popd
}

export FLAMEGRAPH_PATH=/home/wesm/code/FlameGraph

function quickperf {
    perf record -F 999 -g --call-graph=dwarf -- $@
}

function flamegraph {
    perf record -F 999 -g --call-graph=dwarf -- $@
    perf script | c++filt | $FLAMEGRAPH_PATH/stackcollapse-perf.pl > out.perf-folded
    $FLAMEGRAPH_PATH/flamegraph.pl out.perf-folded > perf.svg
}

#----------------------------------------------------------------------
# Spark stuff

export PATH=$HOME/java/maven-3.3.9/bin:$PATH
export SPARK_HOME=$HOME/code/spark
export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"

# ----------------------------------------------------------------------
# Ocaml stuff

. /home/wesm/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
