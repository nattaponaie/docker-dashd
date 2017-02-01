# Dockerfile for Dashd Server
# https://www.dash.org/

FROM alpine:edge
MAINTAINER TheLazieR <thelazier@gmail.com>
LABEL description="Dockerized Dash Daemon"

RUN apk --no-cache --update add libstdc++ curl build-base git tar perl autoconf automake libtool linux-headers patch file bash \
    && git clone -b v0.12.1.x --depth 1 https://github.com/dashpay/dash.git \
    && cd dash \
    # Patch for OpenSSL 1.0.1t (from 1.0.1k)
    && curl -s https://raw.githubusercontent.com/thelazier/docker-dashd/v0.12.1.x/patches/openssl1.0.1t.patch | patch -p1 \
    && cd depends \
    && make NO_QT=1 HOST=x86_64-pc-linux-gnu \
    && cd .. \
    && ./autogen.sh \
    && ./configure --prefix=`pwd`/depends/x86_64-pc-linux-gnu \
    && make install \
    && cp -rv `pwd`/depends/x86_64-pc-linux-gnu/bin/. /usr/local/bin \
    && cp -rv `pwd`/depends/x86_64-pc-linux-gnu/lib/. /usr/local/lib \
    && cd / \
    && apk del build-base git tar perl autoconf automake libtool linux-headers patch file curl\
    && rm -rvf /dash \
    && rm -rvf /var/cache/apk/*

# Create run script
RUN echo $'#!/usr/bin/env bash\n\
set -x\n\
trap '"'"'/usr/local/bin/dash-cli stop'"'"$' SIGTERM\n\
/usr/local/bin/dashd &\n\
while true; do sleep; done\n\
' > /run_dashd.sh && chmod +x /run_dashd.sh && cat /run_dashd.sh

VOLUME ["/root/.dashcore"]
ENTRYPOINT ["/run_dashd.sh"]
EXPOSE 9998 9999 19998 19999

# End.
