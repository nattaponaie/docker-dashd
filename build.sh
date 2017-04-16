#!/bin/sh

# build
apk --update add build-base git tar perl autoconf automake libtool linux-headers patch file bash

# Clone
git clone -b v0.12.2.x --depth 1 https://github.com/dashpay/dash.git

# Compile & Install
cd dash
# Patch for OpenSSL 1.0.1t (from 1.0.1k)
curl -s https://raw.githubusercontent.com/thelazier/docker-dashd/v0.12.1.x/patches/openssl1.0.1t.patch | patch -p1
cd depends
make NO_QT=1 HOST=x86_64-pc-linux-gnu
cd ..
./autogen.sh
./configure --prefix=`pwd`/depends/x86_64-pc-linux-gnu
make
make test
make install
cp -rv `pwd`/depends/x86_64-pc-linux-gnu/bin/. /usr/local/bin
cp -rv `pwd`/depends/x86_64-pc-linux-gnu/lib/. /usr/local/lib

# Cleanup
cd /
apk del build-base git tar perl autoconf automake libtool linux-headers patch file
rm -r /var/cache/apk/*
rm -r /dash

# run.sh
cat > /run.sh << EOF
#!/usr/bin/env bash
trap '/usr/local/bin/dash-cli stop' SIGTERM
/usr/local/bin/dashd
while true; do :; done
EOF
chmod a+x /run.sh
# End
