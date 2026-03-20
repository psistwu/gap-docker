ARG BASE_IMAGE=alpine:3.18
FROM ${BASE_IMAGE} AS builder
ARG GAP_VERSION
RUN apk add build-base autoconf gmp-dev readline-dev zlib-dev wget bash zeromq-dev m4
WORKDIR /opt
RUN wget https://github.com/gap-system/gap/releases/download/v${GAP_VERSION}/gap-${GAP_VERSION}.tar.gz
RUN tar zxvf gap-${GAP_VERSION}.tar.gz && mv gap-${GAP_VERSION} gap
WORKDIR /opt/gap
RUN ./autogen.sh \
    && ./configure \
    && make -j$(nproc)
WORKDIR /opt/gap/pkg
RUN ../bin/BuildPackages.sh
# Note: The default Jupyter Kernel for GAP is not compatible with the latest versions of the Jupyter packages.
# To ensure compatibility, we need to install a specific version of the Jupyter Kernel for GAP.
RUN rm -rf $(ls -d */ | grep -i jupyterkernel) \
    && wget https://github.com/gap-packages/JupyterKernel/archive/refs/heads/master.zip \
    && unzip master.zip \
    && rm master.zip \
    && mv JupyterKernel-master jupyterkernel

ARG BASE_IMAGE=alpine:3.18
FROM ${BASE_IMAGE}
ENV GAP_HOME=/opt/gap
ENV GAP_JUPYTERKERNEL_HOME=${GAP_HOME}/pkg/jupyterkernel
ENV PATH="${GAP_HOME}:${GAP_JUPYTERKERNEL_HOME}/bin:${PATH}"
COPY --from=builder ${GAP_HOME} ${GAP_HOME}
RUN apk add --no-cache python3 py3-pip readline gmp zeromq m4 \
    # Note: The Jupyter Kernel for GAP only works with specific versions of the Jupyter packages.
    # Installing these specific versions ensures compatibility and prevents potential issues that arises
    # from using newer or older versions of the Jupyter packages.
    && pip3 install --break-system-packages ipykernel==6.29.5 jupyter_client==8.6.3 jupyterlab==4.3.3 notebook==7.3.1 \
    && pip install --break-system-packages ${GAP_HOME}/pkg/jupyterkernel
    # && pip3 install ipykernel==6.29.5 jupyter_client==8.6.3 jupyterlab==4.3.3 notebook==7.3.1 \
    # && pip install $GAP_JUPYTERKERNEL_HOME