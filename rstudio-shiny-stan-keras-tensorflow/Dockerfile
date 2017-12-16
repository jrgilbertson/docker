# Use the latest rstudio build as the base
FROM rocker/rstudio:latest

MAINTAINER "Jason Gilbertson" jason.gilbertson@gmail.com

# Add core development tools and environment utilities
RUN apt-get update \ 
  && apt-get install -y --no-install-recommends \
	## for rJava
    default-jdk \
    ## Nice Google fonts
    fonts-roboto \
    ## used by some base R plots
    ghostscript \
    ## used to build rJava and other packages
    libbz2-dev \
    libicu-dev \
    liblzma-dev \
    ## system dependency of hunspell (devtools)
    libhunspell-dev \
    ## system dependency of hadley/pkgdown
    libmagick++-dev \
    ## for V8-based javascript wrappers
    libv8-dev \
    ## for jq queries
    libjq-dev \
    ## R CMD Check wants qpdf to check pdf sizes, or throws a Warning 
    qpdf \
    ## for git via ssh key 
    ssh \
	## fix for the tcltk loading fail
	tk \
	## fix for GL/gl.h missing header
	mesa-common-dev \
	## misc
    libsqlite3-dev \
    libxml2-dev \
	zlib1g-dev \
	vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
RUN install2.r --error \
  devtools \
  testthat

# Add additional R packages not in rstudio build
RUN install2.r --error \
	--deps TRUE \
	tidyverse caret GGally outliers hrbrthemes reprex \
	broom lubridate tidytext sparklyr xgboost syuzhet \
	lime quantmod zoo igraph h2o

# Install rstanarm and dependencies. Multidplyr for parallel tidyverse
RUN apt-get -y --no-install-recommends install \
    ed \
    clang  \
    ccache \
    && install2.r --error \
		--deps TRUE \
        ggstance ggrepel \
        miniUI PKI RCurl RJSONIO packrat minqa nloptr matrixStats inline \
        colourpicker DT dygraphs gtools rsconnect shinyjs shinythemes threejs \
        xts bayesplot lme4 loo rstantools StanHeaders RcppEigen \
        rstan shinystan rstanarm prophet \
    && R -e "library(devtools); \
        install_github('hadley/multidplyr');"

# Add the Keras and Tensorflow packages with Python dependencies
RUN apt-get install python-pip python-virtualenv -y
RUN pip install virtualenv
RUN R -e "devtools::install_github('rstudio/tensorflow')"
RUN R -e "devtools::install_github('rstudio/keras')"
RUN R -e "keras::install_keras(tensorflow = 'gpu')"