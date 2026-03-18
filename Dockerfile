ARG BASE_IMAGE=alpine:3.23.3
FROM ${BASE_IMAGE} AS builder
ARG GAP_VERSION
RUN apk add build-base autoconf gmp-dev readline-dev zlib-dev wget bash zeromq-dev m4
WORKDIR /opt
RUN wget https://github.com/gap-system/gap/releases/download/v${GAP_VERSION}/gap-${GAP_VERSION}.tar.gz
RUN tar zxf gap-${GAP_VERSION}.tar.gz \
    && cd gap-${GAP_VERSION} \
    && ./autogen.sh \
    # Note: The `-Wno-incompatible-pointer-types` flag is used to suppress warnings about incompatible pointer types,
    # which can occur when compiling GAP with certain versions of the C compiler.
    # This is necessary to ensure that the build process completes successfully without being interrupted by these warnings.
    # This flag is particularly relevant for older versions of GAP that may have code that triggers these warnings with newer compilers.
    && CFLAGS="-Wno-incompatible-pointer-types" ./configure \
    && make \
    && cd pkg \
    && ../bin/BuildPackages.sh

ARG BASE_IMAGE=alpine:3.23.3
FROM ${BASE_IMAGE}
ARG GAP_VERSION
ENV GAP_HOME=/opt/gap-${GAP_VERSION}
ENV PATH="${GAP_HOME}/pkg/jupyterkernel/bin:${GAP_HOME}:${PATH}"
COPY --from=builder ${GAP_HOME} ${GAP_HOME}
RUN ln -s ${GAP_HOME} /opt/gap \
    && apk add --no-cache python3 py3-pip readline gmp zeromq m4 \
    # Note: The Jupyter Kernel for GAP only works with specific versions of the Jupyter packages.
    # Installing these specific versions ensures compatibility and prevents potential issues that arises
    # from using newer or older versions of the Jupyter packages.
    && pip3 install --break-system-packages ipykernel==6.29.5 jupyter_client==8.6.3 jupyterlab==4.3.3 notebook==7.3.1 \
    && pip install --break-system-packages ${GAP_HOME}/pkg/jupyterkernel