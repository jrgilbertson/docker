# Use the latest rstudio build as the base
FROM rocker/rstudio:latest

MAINTAINER "Jason Gilbertson" jason.gilbertson@gmail.com

# ---------- Core Development ----------

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		# For rJava
		default-jdk \
		# Used to build rJava and other packages
		libbz2-dev \
		libicu-dev \
		liblzma-dev \
		# System dependency of hunspell (devtools)
		libhunspell-dev \
		# System dependency of hadley/pkgdown
		libmagick++-dev \
		# For git via ssh key 
		ssh \
		# Fix for the tcltk loading fail
		tk \
		# Fix for missing required header GL/gl.h
		mesa-common-dev \
		libglu1-mesa-dev \
		# Fix for fatal error: 'omp.h' file not found
		libomp-dev \
		# Fix for fatal error: 'gsl/gsl_rng.h' file not found
		libgsl-dev \
		# Fix for libmysqlclient not found
		libmariadb-client-lgpl-dev \
		# Add for a couple of packages
		&& R -e "source('https://bioconductor.org/biocLite.R')" \
		# Fix for missing 'graph' package
		&& R -e "BiocInstaller::biocLite('graph')" \
	RUN install2.r --error \
		devtools \
		testthat

# ---------- R Packages ----------

# Add additional R packages not in rstudio build
RUN install2.r --error \
	--deps TRUE \
	tidyverse caret GGally outliers hrbrthemes reprex \
	broom lubridate xgboost syuzhet tidytext sparklyr \
	lime quantmod zoo h2o lintr skimr profvis aws.s3

# ---------- Keras and Tensorflow ----------

# Add the Keras and Tensorflow packages with Python dependencies
RUN apt-get install python-pip python-virtualenv -y
RUN pip install virtualenv
RUN R -e "devtools::install_github('rstudio/tensorflow')"
RUN R -e "devtools::install_github('rstudio/keras')"
RUN R -e "keras::install_keras(tensorflow = 'gpu')"

# ---------- RStan ----------

# Excluding for now given numerous issues with consistent compiling
