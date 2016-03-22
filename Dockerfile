################################################
#
#
#
#
#
################################################

FROM		alpine:3.3
MAINTAINER	Ehud Kaldor <ehud.kaldor@gmail.com>

ENV		S6_LOGGING 1
ENV		S6_VERSION 1.17.2.0
ADD 		https://github.com/just-containers/s6-overlay/releases/download/v$S6_VERSION/s6-overlay-amd64.tar.gz /tmp/
RUN 		gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /

#RUN		echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
# 		apk add --update libressl@testing && \
RUN 		apk add --update dnsmasq jq curl && \
		apk del wget && \
		rm -rf /tmp/* && \
		rm -rf /var/cache/apk/*

ADD		rootfs /

ENTRYPOINT	["/init"]
