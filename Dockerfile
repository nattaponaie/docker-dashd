# Dockerfile for Dashd Server
# https://www.dash.org/

FROM alpine
MAINTAINER TheLazieR <thelazier@gmail.com>
LABEL description="Dockerized Dash Daemon"

RUN apk --update add libstdc++ curl && rm -r /var/cache/apk/*

WORKDIR /
RUN curl -s https://raw.githubusercontent.com/thelazier/docker-dashd/master/build.sh | /bin/sh

ENV DASH_RPCUSER dashrpc
ENV DASH_RPCPASSWORD 4C3NET7icz9zNE3CY1X7eSVrtpnSb6KcjEgMJW3armRV

RUN mkdir /dashdata  \
  && echo '#' > /dashdata/dash.conf \
  && echo rpcuser=$DASH_RPCUSER >> /dashdata/dash.conf \
  && echo rpcpassword=$DASH_RPCPASSWORD >> /dashdata/dash.conf \
  && echo logips=1 > /dashdata/dash.conf \
  && echo printtoconsole=1 > /dashdata/dash.conf \
  && echo daemon=0 > /dashdata/dash.conf \
  && chown -R nobody /dashdata
VOLUME ["/dashdata"]
RUN ln -s /dashdata /.dash
USER nobody
CMD /usr/local/bin/dashd

# End.
