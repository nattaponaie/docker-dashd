#!/bin/sh

# build
apk --update add build-base git tar perl autoconf automake libtool linux-headers patch

# Clone
git clone -b v0.12.1.x --depth 1 https://github.com/dashpay/dash.git

# Compile & Install
cd dash
# Patch for OpenSSL 1.0.1r (from 1.0.1k)
curl "https://patch-diff.githubusercontent.com/raw/dashpay/dash/pull/699.patch" |patch -p1
cd depends
make NO_QT=1 HOST=x86_64-pc-linux-gnu
cd ..
./autogen.sh
./configure --prefix=`pwd`/depends/x86_64-pc-linux-gnu
make
make test
make install
cp -rv `pwd`/depends/x86_64-pc-linux-gnu/. /usr/local/.

# Cleanup
cd /
apk del build-base git tar perl autoconf automake libtool linux-headers patch
rm -r /var/cache/apk/*
rm -r /dash
