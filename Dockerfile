# Dockerfile for Dashd Server
# https://www.dash.org/

FROM alpine
MAINTAINER TheLazieR <thelazier@gmail.com>
LABEL description="Dockerized Dash Daemon"

WORKDIR /
RUN apk --no-cache add \
  alpine-sdk \
  wget \
  libtool \
  autoconf \
  automake \
  boost-dev \
  openssl-dev \
  db-dev \
  protobuf-dev \
  p7zip \
  git \
  && git clone -b master --depth 10 https://github.com/dashpay/dash.git \
  && cd dash \
  && ./autogen.sh \
  && ./configure --with-incompatible-bdb --with-utils --enable-hardening \
  && make \
  && make install \
  && mkdir /root/.dash \
  && cd /root/.dash \
  && wget -qO bootstrap.7z $(wget -qO- https://raw.githubusercontent.com/UdjinM6/dash-bootstrap/master/links.md | cut -d '(' -f 2 |cut -d ')' -f 1 |grep 7z |head -1) \
  && 7za e -y bootstrap.7z \
  && rm -f bootstrap.7z \
  && apk del libtool autoconf automake alpine-sdk wget git \
  && ldd /usr/local/bin/dashd \
  && cd / \
  && rm -rf /dash

ENV DASH_RPCUSER dashrpc
ENV DASH_RPCPASSWORD 4C3NET7icz9zNE3CY1X7eSVrtpnSb6KcjEgMJW3armRV

RUN echo '#' > /root/.dash/dash.conf \
  && echo rpcuser=$DASH_RPCUSER >> /root/.dash/dash.conf \
  && echo rpcpassword=$DASH_RPCPASSWORD >> /root/.dash/dash.conf 
EXPOSE 9998 9999
CMD /usr/local/bin/dashd -disablewallet -logips -printtoconsole -daemon=0
# End.
