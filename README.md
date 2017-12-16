# Docker build for the ultimate R data science machine

This is an in-progress build for R which includes RStudio, Shiny, Stan, Keras and Tensorflow along with the major statisitical and machine learning packages.

The purpose of this build is for R&D and exploratory work. It would be more Docker-esque if this was broken into multiple, more focused builds. For exploratory work, however, I prefer to reduce friction so the goal is to integrate the main tools into one build.

***This build is in progress and not yet complete.***

# Quickstart

Start with the default options of user = rstudio and password = rstudio. This is **not recommended** for public instances.

```docker run -d -p 8787:8787 jrgilbertson/rstudio-shiny-stan-keras-tensorflow```

Start with user-defined user and password.

```docker run -d -p 8787:8787 -e USER=<username> -e PASSWORD=<password> jrgilbertson/rstudio-shiny-stan-keras-tensorflow```

Start with user-defined user and password with root access.

```docker run -d -p 8787:8787 -e USER=<username> -e PASSWORD=<password> -e ROOT=TRUE jrgilbertson/rstudio-shiny-stan-keras-tensorflow```

Add a Shiny server on startup.

```docker run -d -p 3838:3838 -p 8787:8787 -e ADD=shiny jrgilbertson/rstudio-shiny-stan-keras-tensorflow```

# References

This configuration builds on the great work from [rocker-org](https://github.com/rocker-org). More information on how to use the base of this configuration can be found at [Using-the-RStudio-image](https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image).