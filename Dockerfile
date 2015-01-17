FROM  ipython/scipystack

MAINTAINER John McCallum john.mccallum@plantandfood.co.nz

# Set noninterative mode
ENV DEBIAN_FRONTEND noninteractive

################## BEGIN INSTALLATION ######################

## ipython/ipython is 14.04 (trusty) and ncurses is for samtools and precise dependencies are unresolved
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list

## Install _all_ prerequisites in hope that they do not change much.
## follow recommendations https://docs.docker.com/articles/dockerfile_best-practices/#run
RUN set -xe ;\
  apt-get update ;\
  apt-get upgrade -y ;\
  apt-get install -y \
    asciidoc \
    libncurses5-dev \
    wget

## Note tweak to set Python 2.7 default
RUN set -xe ;\
  apt-get update ;\
  apt-get install python-biopython -y; \
  sed -i 's/python3/python2/' /usr/local/bin/ipython; \
  pip install terminado bcbio-gff

## Install Primer3
RUN apt-get install -y primer3
## Install vcf utils

WORKDIR /tmp
ADD http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.12b.tar.gz /tmp/vcftools.tar.gz

## Install VCF tools
RUN set -xe ;\
  tar -zxf vcftools.tar.gz ;\
  cd vcftools_* ;\
  make install PREFIX=/usr/local

ENV PERL5LIB /usr/local/lib/perl5

## Install VCF lib
RUN set -xe ;\
  cachebust=ce69f84cf5 git clone --recursive https://github.com/ekg/vcflib.git ;\
  cd vcflib ;\
  make ;\
  cp ./bin/* /usr/local/bin/

## Install HTS lib
RUN set -xe ;\
  cachebust=dfd67733e1 git clone --branch=develop https://github.com/samtools/htslib.git ;\
  cd htslib ;\
  make ;\
  make test ;\
  make install

## Install BCF tools
RUN set -xe ;\
  cachebust=18444012a9 git clone --branch=develop https://github.com/samtools/bcftools.git ;\
  cd bcftools ;\
  make HTSDIR=/tmp/htslib;\
  make test ;\
  make install

## Install samtools
RUN set -xe ;\
  cachebust=29b03673d6 git clone --branch=develop https://github.com/samtools/samtools.git ;\
  cd samtools ;\
  make HTSDIR=/tmp/htslib;\
  make test ;\
  make install

## Install bedtools plus Python interface
RUN set -xe ;\
   apt-get -y install bedtools;\
   pip install pybedtools

## Install Beagle 4
ADD http://faculty.washington.edu/browning/beagle/beagle.r1398.jar /usr/local/bin/beagle.jar


## set up for Gisting Notebooks
RUN set -xe ;\
  apt-get  install -y  ruby; \
  gem install gist

####### R install ######################
## Following https://registry.hub.docker.com/u/rocker/r-base/dockerfile ####

## Use Debian repo at CRAN, and use RStudio CDN as mirror
## This gets us updated r-base, r-base-dev, r-recommended and littler
RUN apt-key adv --keyserver keys.gnupg.net --recv-key 381BA480 \
    && echo "deb http://cran.rstudio.com/bin/linux/debian wheezy-cran3/" > /etc/apt/sources.list.d/r-cran.list

ENV R_BASE_VERSION 3.1.2

## Now install R and littler, and create a link for littler in /usr/local/bin
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
            littler \
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



##########################################

### Launch ipynb as default

CMD ipython notebook --ip=0.0.0.0 --port=8888 --no-browser

##################### INSTALLATION END #####################

## TEST
ADD test-suite.sh /tmp/test-suite.sh
RUN ./test-suite.sh

## Clean up
RUN rm -rf /tmp/*
