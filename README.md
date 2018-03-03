# Docker build for the ultimate R data science machine

R data science machine which includes RStudio, Shiny, Stan, Keras and Tensorflow along with the major statisitical and machine learning packages.

The purpose of this build is for R&D and exploratory work. It would be more Docker-esque if this was broken into multiple, more focused builds. For exploratory work, however, I prefer to reduce friction so the goal is to integrate the main tools into one build.

# Quickstart

Start with the default options of user = rstudio and password = rstudio. This is **not recommended** for public instances.

```docker run -d -p 8787:8787 -p 8888:8888 jrgilbertson/r_data_science_machine```

Start with user-defined user and password.

```docker run -d -p 8787:8787 -p 8888:8888 -e USER=<username> -e PASSWORD=<password> jrgilbertson/r_data_science_machine```

Start with user-defined user and password with root access.

```docker run -d -p 8787:8787 -p 8888:8888 -e USER=<username> -e PASSWORD=<password> -e ROOT=TRUE jrgilbertson/r_data_science_machine```

Add a Shiny server on startup.

```docker run -d -p 3838:3838 -p 8787:8787 -p 8888:8888 -e ADD=shiny jrgilbertson/r_data_science_machine```

Add a local file volume. Note ```/home/rstudio``` in the remote file path.

```docker run -d -p 8787:8787 -p 8888:8888 -v /local/file/path:/home/rstudio/remote/file/path jrgilbertson/r_data_science_machine```

# Using Jupyter Notebook

This build is primarily geared towards RStudio but for Python development I prefer to use Jupyter. To start a Jupyter Notebook after you have already run one of the above quickstart commands (and thanks to [Towards Data Science](https://towardsdatascience.com/setting-up-and-using-jupyter-notebooks-on-aws-61a9648db6c5) for this simpler approach of getting a remote notebook working):

Start the Jupyter Notebook on the remote machine:

SSH in and start Jupyter with ```sudo docker exec -ti [docker_image_name] sh -c "jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser"```. Note that if you have trouble getting this working can also use the terminal within RStudio.

On the local machine:

Create another SSH connection with port forwarding by entering ```ssh -i key.pem -L 8000:localhost:8888 user@address```. If you use Putty go to Connection | SSH | Tunnels and set source port of 8000 and destination port of localhost:8888.

Once the SSH connection is established go to your web browser and type ```http://localhost:8000```. For the first login you may need to copy the token provided when you start the Jupyter Notebook.

# Volumes

Mounting a local volume is tricky depending on your local OS. Start with [sharing files with host machine](https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine) from the rocker-org team. If your local machine is Windows use the PowerShell CLI for better handling of file paths.

# References

This configuration builds on the great work from [rocker-org](https://github.com/rocker-org). More information on how to use the base of this configuration can be found at [Using-the-RStudio-image](https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image).
