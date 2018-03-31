# Use the latest RStudio build as the base
FROM rocker/rstudio:latest

MAINTAINER "Jason Gilbertson" jason.gilbertson@gmail.com

# ---------- Core Development ----------

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		default-jdk \
		libbz2-dev \
		libicu-dev \
		liblzma-dev \
		libxml2-dev \
		libcairo2-dev \
		libsqlite3-dev \
		libmariadbd-dev \
		libmariadb-client-lgpl-dev \
		libpq-dev \
		libssh2-1-dev \
		unixodbc-dev \
		libmagick++-dev \
		libssl-dev \
		ed \
		clang \
		ccache \
		&& R -e "source('https://bioconductor.org/biocLite.R')"

# ---------- R Packages without RStan ----------

# Breaking this up in sections due to high chance of packages failing
RUN install2.r --error --deps TRUE devtools formatR selectr caTools remotes
RUN install2.r --error --deps TRUE tidyverse caret GGally outliers hrbrthemes reprex
RUN install2.r --error --deps TRUE lime quantmod zoo h2o lintr skimr profvis aws.s3

# ---------- RStan Configuration ----------

# Source: https://hub.docker.com/r/andrewheiss/tidyverse-rstanarm/~/dockerfile/
# Starting with Stan as requires the most manual configuration and is a dependency
# for some other packages. Docker Hub (and Docker in general) chokes on memory issues
# when compiling with gcc, so copy custom CXX settings to /root/.R/Makevars and use
# ccache and clang++ instead
RUN mkdir -p $HOME/.R/ \
	&& echo "\nCXX=clang++ -ftemplate-depth-256\n" >> $HOME/.R/Makevars \
	&& echo "CC=clang\n" >> $HOME/.R/Makevars

# ---------- R Packages with RStan ----------

# Breaking this up in sections due to high chance of packages failing
RUN install2.r --error --deps TRUE broom lubridate xgboost syuzhet tidytext sparklyr

# ---------- Keras and Tensorflow ----------

# Add the Keras and Tensorflow packages with Python dependencies
RUN apt-get install python-pip python-virtualenv -y
RUN pip install virtualenv
RUN R -e "devtools::install_github('rstudio/tensorflow')"
RUN R -e "devtools::install_github('rstudio/keras')"
RUN R -e "devtools::install_github('rstudio/tfestimators')"
RUN R -e "keras::install_keras(tensorflow = 'gpu')"
