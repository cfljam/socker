FROM  cfljam/socker

MAINTAINER John McCallum john.mccallum@plantandfood.co.nz


####### R install ######################
## Following https://registry.hub.docker.com/u/rocker/r-base/dockerfile ####

RUN useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker \
  && addgroup docker staff

RUN aptitude update && aptitude install -y --without-recommends \
    ed \
    less \
    locales \
    vim-tiny \
    wget \
    libicu-dev\
    libpango-1.0-0\
  && rm -rf /var/lib/apt/lists/*

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen en_US.utf8 \
  && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8

## Use Ubuntu repo at CRAN, and use RStudio CDN as mirror
## This gets us updated r-base, r-base-dev, r-recommended and littler
RUN gpg --keyserver pgpkeys.mit.edu --recv-key 51716619E084DAB9  \
&& gpg -a --export 51716619E084DAB9 | sudo apt-key add  - \
  && echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" > /etc/apt/sources.list.d/r-cran.list

ENV R_BASE_VERSION 3.1.2

## Now install R and littler, and create a link for littler in /usr/local/bin
RUN aptitude update -q \
  && aptitude install -y --without-recommends \
      littler \
      r-base-core=${R_BASE_VERSION}* \
      r-base=${R_BASE_VERSION}* \
      r-base-dev=${R_BASE_VERSION}* \
      r-recommended=${R_BASE_VERSION}* \
  && ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
  && ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
  && ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
  && ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
  && install.r docopt \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
  && rm -rf /var/lib/apt/lists/*


## Set a default CRAN Repo
RUN echo 'options(repos = list(CRAN = "http://cran.rstudio.com/"))' >> /etc/R/Rprofile.site

## Install the R packages
RUN install2.r --error \
    devtools \
    dplyr \
    ggplot2 \
    reshape2 \
    data.table\
    ggvis \
    tidyr \
#    RPostgresql \
  &&  Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite("Gviz")'


## Install rpy2
RUN python2 /usr/local/bin/pip   --default-timeout=100 install rpy2




##########################################

### Launch ipynb as default

CMD ipython notebook --ip=0.0.0.0 --port=8889 --no-browser

##################### INSTALLATION END #####################

## TEST
#ADD ../test-suite.sh /tmp/test-suite.sh
#RUN ./test-suite.sh

## Clean up
RUN rm -rf /tmp/*
