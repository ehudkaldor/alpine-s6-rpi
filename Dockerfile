################################################
#
#
#
#
#
################################################

FROM		alpine:3.3
MAINTAINER	Ehud Kaldor <ehud.kaldor@gmail.com>

ENV		S6_VERSION 1.17.1.2
ADD 		https://github.com/just-containers/s6-overlay/releases/download/v$S6_VERSION/s6-overlay-amd64.tar.gz /tmp/
RUN 		gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /

#RUN 		apk add --no-cache wget \
# 		&& wget https://github.com/just-containers/s6-overlay/releases/download/v1.17.1.2/s6-overlay-amd64.tar.gz --no-check-certificate -O /tmp/s6-overlay.tar.gz \
#		&& tar xvfz /tmp/s6-overlay.tar.gz -C / \
#		&& rm -f /tmp/s6-overlay.tar.gz \
#		&& apk del wget

ENV 		S6_LOGGING="1"

ADD		rootfs /
ENTRYPOINT	["/init"]
