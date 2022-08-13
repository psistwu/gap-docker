FROM debian:bullseye-20220801-slim AS builder
ARG HOME=/home/gap
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
WORKDIR ${HOME}
RUN wget https://github.com/gap-system/gap/releases/download/v${GAP_VERSION}/gap-${GAP_VERSION}.tar.gz \
    && tar zxf gap-${GAP_VERSION}.tar.gz \
    && cd gap-${GAP_VERSION} \
    && ./configure \
    && make \
    && cd bin \
    && ln -sf gap.sh gap \
    && cd ../pkg \
    && ../bin/BuildPackages.sh \
    && mv JupyterKernel-* JupyterKernel


FROM debian:bullseye-20220801-slim
ARG GAP_VERSION
ENV HOME=/home/gap
ENV GAP_HOME=${HOME}/gap-${GAP_VERSION}
ENV JUPYTER_GAP_EXECUTABLE ${GAP_HOME}/bin/gap
ENV PATH ${GAP_HOME}/bin:${GAP_HOME}/pkg/JupyterKernel/bin:${PATH}
COPY --from=builder ${GAP_HOME} ${GAP_HOME}
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        libncurses6 \
        libreadline8 \
        python3-pip \
        sudo \
    && pip install \
        notebook \
        jupyterlab \
        jupyterlab_launcher \
        traitlets \
        ipython \
        vdom \
    && adduser --quiet --shell /bin/bash --gecos "GAP user,101,," --disabled-password gap \
    && adduser gap sudo \
    && chown -R gap:gap ${HOME} \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && touch ${HOME}/.sudo_as_admin_successful
USER gap
RUN cd ${GAP_HOME}/pkg/JupyterKernel \
    && python3 setup.py install --user \
    && jupyter serverextension enable --py jupyterlab --user
WORKDIR ${HOME}