FROM debian:bullseye-20220801-slim AS builder
ARG GAP_VERSION
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        autoconf \
        autogen \
        automake \
        build-essential \
        cmake \
        curl \
        g++ \
        gcc \
        gcc-multilib \
        git \
        libboost-dev \
        libcdd-dev \
        libcurl4-openssl-dev \
        libflint-dev \
        libglpk-dev \
        libgmp-dev \
        libgmpxx4ldbl \
        libmpc-dev \
        libmpfi-dev \
        libmpfr-dev \
        libncurses5-dev \
        libntl-dev \
        libreadline6-dev \
        libtool \
        libxml2-dev \
        libzmq3-dev \
        m4 \
        mercurial \
        polymake \
        python3-pip \
        sudo \
        unzip \
        wget
WORKDIR /srv
RUN wget https://github.com/gap-system/gap/releases/download/v${GAP_VERSION}/gap-${GAP_VERSION}.tar.gz \
    && tar zxf gap-${GAP_VERSION}.tar.gz \
    && cd gap-${GAP_VERSION} \
    && ./configure \
    && make \
    && cp bin/gap.sh bin/gap \
    && cd pkg \
    && ../bin/BuildPackages.sh \
    && mv JupyterKernel-* JupyterKernel


FROM debian:bullseye-20220801-slim
ARG GAP_VERSION
ENV GAP_HOME=/srv/gap-${GAP_VERSION}
ENV JUPYTER_GAP_EXECUTABLE ${GAP_HOME}/bin/gap
ENV PATH ${GAP_HOME}/bin:${GAP_HOME}/pkg/JupyterKernel/bin:${PATH}
COPY --from=builder --chown=root:root ${GAP_HOME} ${GAP_HOME}
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        libncurses6 \
        libreadline8 \
        libzmq5 \
        python3-pip \
        sudo \
    && pip install \
        notebook \
        jupyterlab \
        jupyterlab_launcher \
        traitlets \
        ipython \
        vdom \
    && cd ${GAP_HOME}/pkg/JupyterKernel \
    && python3 setup.py install \
    && jupyter serverextension enable --py jupyterlab
WORKDIR /srv
