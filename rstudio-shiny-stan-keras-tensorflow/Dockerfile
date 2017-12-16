# Use the latest rstudio build as the base
FROM rocker/rstudio:latest

MAINTAINER "Jason Gilbertson" jason.gilbertson@gmail.com

# ---------- Core Development ----------

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		## for rJava
		default-jdk \
		## used to build rJava and other packages
		libbz2-dev \
		libicu-dev \
		liblzma-dev \
		## system dependency of hunspell (devtools)
		libhunspell-dev \
		## system dependency of hadley/pkgdown
		libmagick++-dev \
		## for git via ssh key 
		ssh \
		## fix for the tcltk loading fail
		tk \
		## fix for missing required header GL/gl.h
		mesa-common-dev \
		libglu1-mesa-dev \
		## Add for a couple of packages
		&& R -e "source('https://bioconductor.org/biocLite.R')" \
	# && apt-get clean \
	# && rm -rf /var/lib/apt/lists/ \
	# && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
RUN install2.r --error \
	devtools \
	testthat
	
# ---------- Stan ----------

# Source: https://hub.docker.com/r/andrewheiss/tidyverse-rstanarm/~/dockerfile/

# RUN R -e "devtools::install_github('omegahat/Rcompression')"

# Starting with Stan as requires the most manual configuration and is a dependency 
# for some other packages. Docker Hub (and Docker in general) chokes on memory issues 
# when compiling with gcc, so copy custom CXX settings to /root/.R/Makevars and use 
# ccache and clang++ instead

# Make ~/.R
# RUN mkdir -p $HOME/.R
# $HOME doesn't exist in the COPY shell, so be explicit
# COPY R/Makevars /root/.R/Makevars

RUN mkdir -p $HOME/.R/ \
	&& echo "\nCXX=clang++ -ftemplate-depth-256\n" >> $HOME/.R/Makevars \
	&& echo "CC=clang\n" >> $HOME/.R/Makevars

# Install ggplot extensions like ggstance and ggrepel
# Install ed, since nloptr needs it to compile.
# Install all the dependencies needed by rstanarm and friends
# Install multidplyr for parallel tidyverse magic
RUN apt-get -y --no-install-recommends install \
    ed \
    clang  \
    ccache \
    && install2.r --error \
        ggstance ggrepel \
        miniUI PKI RCurl RJSONIO packrat minqa nloptr matrixStats inline \
        colourpicker DT dygraphs gtools rsconnect shinyjs shinythemes threejs \
        xts bayesplot lme4 loo rstantools StanHeaders RcppEigen \
        rstan shinystan rstanarm \
    && R -e "library(devtools); \
        install_github('hadley/multidplyr');"

# ---------- Keras and Tensorflow ----------

# Add the Keras and Tensorflow packages with Python dependencies
RUN apt-get install python-pip python-virtualenv -y
RUN pip install virtualenv
RUN R -e "devtools::install_github('rstudio/tensorflow')"
RUN R -e "devtools::install_github('rstudio/keras')"
RUN R -e "keras::install_keras(tensorflow = 'gpu')"

# Add additional R packages not in rstudio build
RUN install2.r --error \
	--deps TRUE \
	tidyverse caret GGally outliers hrbrthemes reprex \
	broom lubridate tidytext sparklyr xgboost syuzhet \
	lime quantmod zoo igraph h2o