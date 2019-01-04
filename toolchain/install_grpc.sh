mkdir -p build
pushd build

INSTALL_PREFIX=$HOME/local

export PKG_CONFIG_PATH=$HOME/cpp-toolchain/lib/pkgconfig
SSL_ROOT=$HOME/cpp-toolchain

TOOLCHAIN_DIR=$HOME/cpp-toolchain

cmake ~/code/grpc  \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_CXX_FLAGS="-fPIC" \
      -DCMAKE_PREFIX_PATH=$TOOLCHAIN_DIR \
      -DgRPC_CARES_PROVIDER="package" \
      -DgRPC_GFLAGS_PROVIDER="package" \
      -DgRPC_PROTOBUF_PROVIDER="package" \
      -DgRPC_SSL_PROVIDER="package" \
      -DgRPC_ZLIB_PROVIDER="package" \
      -DOPENSSL_ROOT_DIR=$SSL_ROOT \
      -DCMAKE_INSTALL_PREFIX:PATH=$TOOLCHAIN_DIR
cmake --build . --config Release --target install

popd
rm -rf build
