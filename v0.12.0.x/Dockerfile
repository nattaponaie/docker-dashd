# Dockerfile for Dashd Server
# https://www.dash.org/

FROM alpine
MAINTAINER TheLazieR <thelazier@gmail.com>
LABEL description="Dockerized Dash Daemon"

RUN apk --update add libstdc++ curl && rm -r /var/cache/apk/*

WORKDIR /
RUN curl -s https://raw.githubusercontent.com/thelazier/docker-dashd/master/v0.12.0.x/build.sh | /bin/sh

ENV DASH_RPCUSER dashrpc
ENV DASH_RPCPASSWORD 4C3NET7icz9zNE3CY1X7eSVrtpnSb6KcjEgMJW3armRV
USER nobody

RUN mkdir /tmp/dash \
  && echo '#' > /tmp/dash/dash.conf \
  && echo rpcuser=$DASH_RPCUSER >> /tmp/dash/dash.conf \
  && echo rpcpassword=$DASH_RPCPASSWORD >> /tmp/dash/dash.conf
CMD /usr/local/bin/dashd -logips -printtoconsole -daemon=0 -datadir=/tmp/dash
# End.
