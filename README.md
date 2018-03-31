# Docker build for the ultimate R data science machine

R data science machine which includes RStudio, Shiny, Keras and Tensorflow along with the major statisitical and machine learning packages.

The purpose of this build is for R&D and exploratory work. It would be more Docker-esque if this was broken into multiple, more focused images. For exploratory work, however, I prefer to reduce friction so the goal is to integrate the main tools into one build.

# Quickstart

Start with the default options of user = rstudio and password = rstudio. This is **not recommended** for public instances.

```docker run -d -p 8787:8787 jrgilbertson/r_data_science_machine```

Start with user-defined user and password.

```docker run -d -p 8787:8787 -e USER=<username> -e PASSWORD=<password> jrgilbertson/r_data_science_machine```

Start with user-defined user and password with root access.

```docker run -d -p 8787:8787 -e USER=<username> -e PASSWORD=<password> -e ROOT=TRUE jrgilbertson/r_data_science_machine```

Add a Shiny server on startup.

```docker run -d -p 3838:3838 -p 8787:8787 -e ADD=shiny jrgilbertson/r_data_science_machine```

Add a local file volume. Note ```/home/rstudio``` in the remote file path.

```docker run -d -p 8787:8787 -v /local/file/path:/home/rstudio/remote/file/path jrgilbertson/r_data_science_machine```

# Volumes

Mounting a local volume is tricky depending on your local OS. Start with [sharing files with host machine](https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine) from the rocker-org team. If your local machine is Windows use the PowerShell CLI for better handling of file paths.

# References

This configuration builds on the great work from [rocker-org](https://github.com/rocker-org). More information on how to use the base of this configuration can be found at [Using-the-RStudio-image](https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image).
