# Use the latest RStudio
FROM rocker/rstudio:latest

MAINTAINER "Jason Gilbertson" jason.gilbertson@gmail.com

# ---------- Core Development ----------

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-utils \
		default-jdk \
		libbz2-dev \
		libcairo2-dev \
		libcurl4-openssl-dev \
		libglu1-mesa-dev \
		libgsl0-dev \
		libhunspell-dev \
		libicu-dev \
		liblzma-dev \
		libmagick++-dev \
		libmariadb-client-lgpl-dev \
		libmariadbd-dev \
		libnlopt-dev \
		libomp-dev \
		libpq-dev \
		libsqlite3-dev \
		libssh2-1-dev \
		libssl-dev \
		libxml2-dev \
		mesa-common-dev \
		ssh \
		tk \
		unixodbc-dev \
		&& R -e "source('https://bioconductor.org/biocLite.R')"

# ---------- RStan Configuration ----------

# Global site-wide config for building packages
RUN mkdir -p $HOME/.R/ \
    && echo "CXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -flto -ffat-lto-objects  -Wno-unused-local-typedefs \n" >> $HOME/.R/Makevars

# Install ggplot extensions like ggstance and ggrepel
# Install ed, since nloptr needs it to compile
# Install all the dependencies needed by rstanarm and friends
RUN apt-get -y --no-install-recommends install \
    ed \
    clang  \
    ccache \
    && install2.r --error \
        ggstance ggrepel \
        miniUI PKI RCurl RJSONIO packrat minqa nloptr matrixStats inline \
        colourpicker DT dygraphs gtools rsconnect shinyjs shinythemes threejs \
        xts bayesplot lme4 loo rstantools StanHeaders RcppEigen \
        rstan shinystan rstanarm broom

# ---------- Various R Packages ----------

# Breaking this up in sections due to high chance of packages failing
RUN install2.r --error --deps TRUE devtools formatR selectr caTools remotes
RUN install2.r --error --deps TRUE tidyverse caret GGally outliers hrbrthemes reprex
RUN install2.r --error --deps TRUE lime quantmod zoo h2o lintr skimr profvis aws.s3
RUN install2.r --error --deps TRUE lubridate xgboost syuzhet tidytext sparklyr
RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# ---------- NVIDIA Drivers ----------

# Add required libraries
RUN apt-get -y --no-install-recommends install gnupg

# Step 1 on base machine: https://tensorflow.rstudio.com/tools/local_gpu.html
# Step 2 on base machine: https://github.com/NVIDIA/nvidia-docker
# Source: https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/9.0/runtime/cudnn7/Dockerfile
# NVIDIA base: https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/9.0/base/Dockerfile
RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
    NVIDIA_GPGKEY_FPR=ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80 && \
    apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
    apt-key adv --export --no-emit-version -a $NVIDIA_GPGKEY_FPR | tail -n +5 > cudasign.pub && \
    echo "$NVIDIA_GPGKEY_SUM  cudasign.pub" | sha256sum -c --strict - && rm cudasign.pub && \
    echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV CUDA_VERSION 9.0.176

ENV CUDA_PKG_VERSION 9-0=$CUDA_VERSION-1
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION && \
    ln -s cuda-9.0 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# nvidia-docker 1.0
LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"

# NVIDIA runtime: https://gitlab.com/nvidia/cuda/blob/ubuntu16.04/9.0/runtime/Dockerfile
ENV NCCL_VERSION 2.1.15

RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-libraries-$CUDA_PKG_VERSION \
        libnccl2=$NCCL_VERSION-1+cuda9.0 && \
    rm -rf /var/lib/apt/lists/*

# NVIDIA cuDNN
ENV CUDNN_VERSION 7.1.2.21
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+cuda9.0 && \
    rm -rf /var/lib/apt/lists/*
