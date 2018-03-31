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
		&& R -e "source('https://bioconductor.org/biocLite.R')"

# ---------- R Packages ----------

# Add additional R packages not in RStudio build
RUN install2.r --error \
	--deps TRUE \
	devtools formatR selectr caTools remotes \
	#tidyverse caret GGally outliers hrbrthemes reprex \
	#broom lubridate xgboost syuzhet tidytext sparklyr \
	lime quantmod zoo h2o lintr skimr profvis aws.s3

# ---------- Keras and Tensorflow ----------

# Add the Keras and Tensorflow packages with Python dependencies
RUN apt-get install python-pip python-virtualenv -y
RUN pip install virtualenv
RUN R -e "devtools::install_github('rstudio/tensorflow')"
RUN R -e "devtools::install_github('rstudio/keras')"
RUN R -e "keras::install_keras(tensorflow = 'gpu')"
