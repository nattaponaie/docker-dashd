#!/bin/sh

# build
apk --update add build-base git tar perl autoconf automake libtool linux-headers patch wget

# Clone
git clone -b master --depth 1 https://github.com/dashpay/dash.git

# Compile & Install
cd dash
# Patch for miniupnpc 1.9-20151026
# curl "https://patch-diff.githubusercontent.com/raw/dashpay/dash/pull/657.patch" |patch -p1
curl -s https://raw.githubusercontent.com/thelazier/docker-dashd/master/patches/miniupnpc1.9-20151026.patch |patch -p1
# Patch for Boost 1.59 (from 1.55)
# curl "https://patch-diff.githubusercontent.com/raw/dashpay/dash/pull/658.patch" |patch -p1
curl -s https://raw.githubusercontent.com/thelazier/docker-dashd/master/patches/boost1.59.patch |patch -p1
# Patch for OpenSSL 1.0.1t (from 1.0.1k)
curl -s https://raw.githubusercontent.com/thelazier/docker-dashd/master/patches/openssl1.01t.patch |patch -p1
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
apk del build-base git tar perl autoconf automake libtool linux-headers patch wget
rm -r /var/cache/apk/*
rm -r /dash

# run.sh
cat > /run.sh << EOF
#!/usr/bin/env bash
trap '/usr/local/bin/dash-cli stop' SIGTERM
/usr/local/bin/dashd
while true; do :; done
EOF

# End
