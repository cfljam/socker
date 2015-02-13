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
  apt-get update;\
  apt-get -y upgrade;\
  apt-get -y dist-upgrade ;\
  apt-get autoremove;\
  apt-get autoclean;\
  apt-get install -y --no-install-recommends\
    asciidoc \
    libncurses5-dev \
    nano\
    aptitude\
    wget

## Note tweak to set Python 2.7 default
RUN set -xe ;\
  aptitude update ;\
  aptitude install -y python-setuptools;\
  aptitude install -y python-biopython ; \
  sed -i 's/python3/python2/' /usr/local/bin/ipython

## Install Primer3
RUN aptitude install -y primer3
## Install vcf utils


## Download VCF tools
WORKDIR /tmp
ADD http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.12b.tar.gz /tmp/vcftools.tar.gz

## Install VCF tools
RUN set -xe ;\
  tar -zxf vcftools.tar.gz ;\
  cd vcftools_*;\
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
   aptitude -y install bedtools


## Install JRE for Beagle
RUN aptitude install -y openjdk-7-jre

## Install Beagle 4
ADD http://faculty.washington.edu/browning/beagle/beagle.r1398.jar /usr/local/bin/beagle.jar

## set up for Gisting Notebooks
RUN set -xe ;\
  aptitude  install -y  ruby; \
  gem install gist

### Install python packages
### Note explicit use of Py version to avoid pip version issues
ADD requirements.txt /tmp/
RUN set -xe ;\
python2 /usr/local/bin/pip   --default-timeout=100 install -r /tmp/requirements.txt


##########################################

### Launch ipynb as default

CMD ipython notebook --ip=0.0.0.0 --port=8888 --no-browser

##################### INSTALLATION END #####################

## TEST
ADD test-suite.sh /tmp/test-suite.sh
RUN ./test-suite.sh

## Clean up
RUN rm -rf /tmp/*
