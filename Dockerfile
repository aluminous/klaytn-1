# Global ARGs
ARG DOCKER_BASE_IMAGE=klaytn/build_base:1.0-go1.14.1-solc0.4.24
ARG PKG_DIR=/klaytn-docker-pkg
ARG SRC_DIR=/go/src/github.com/klaytn/klaytn

FROM ${DOCKER_BASE_IMAGE} AS builder
LABEL maintainer="Austin Brown <austin.brown@groundx.xyz>"
ARG SRC_DIR
ARG PKG_DIR

ARG KLAYTN_RACE_DETECT=0
ENV KLAYTN_RACE_DETECT=$KLAYTN_RACE_DETECT

ADD . $SRC_DIR
RUN cd $SRC_DIR && make all

FROM alpine:3
ARG SRC_DIR
ARG PKG_DIR

RUN mkdir -p $PKG_DIR/conf $PKG_DIR/bin

# packaging
COPY --from=builder $SRC_DIR/build/bin/* $PKG_DIR/bin/

COPY --from=builder $SRC_DIR/build/packaging/linux/bin/* $PKG_DIR/bin/

COPY --from=builder $SRC_DIR/build/packaging/linux/conf/* $PKG_DIR/conf/

COPY --from=builder $SRC_DIR/build/bin/* /usr/bin/

EXPOSE 8551 8552 32323 61001 32323/udp
