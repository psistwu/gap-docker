ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION} AS builder
ARG GAP_VERSION
RUN apk add build-base autoconf gmp-dev readline-dev zlib-dev wget bash zeromq-dev
WORKDIR /opt
RUN wget https://github.com/gap-system/gap/releases/download/v${GAP_VERSION}/gap-${GAP_VERSION}.tar.gz
RUN tar zxf gap-${GAP_VERSION}.tar.gz \
    && cd gap-${GAP_VERSION} \
    && ./autogen.sh \
    && CFLAGS="-Wno-incompatible-pointer-types" ./configure \
    && make \
    && cd pkg \
    && ../bin/BuildPackages.sh

ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}
ARG GAP_VERSION
ENV GAP_HOME=/opt/gap-${GAP_VERSION}
ENV PATH="${GAP_HOME}/pkg/jupyterkernel/bin:${GAP_HOME}:${PATH}"
COPY --from=builder ${GAP_HOME} ${GAP_HOME}
RUN apk add --no-cache python3 py3-pipreadline gmp zeromq