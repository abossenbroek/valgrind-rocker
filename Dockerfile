## Emacs, make this -*- mode: sh; -*-
 
FROM rocker/r-base:latest

## This handle reaches Anton 
MAINTAINER "Anton Bossenbroek" anton.bossenbroek@me.com

RUN apt-get update \ 
  && apt-get install -y --no-install-recommends \
    ghostscript \
    imagemagick \
    lmodern \
    texlive-fonts-recommended \
    texlive-humanities \
    texlive-latex-extra \
    texinfo \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev \
    build-essential \
    valgrind \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/ \
 && cd /usr/share/texlive/texmf-dist \
 && wget http://mirrors.ctan.org/install/fonts/inconsolata.tds.zip \
 && unzip inconsolata.tds.zip \
 && rm inconsolata.tds.zip \
 && echo "Map zi4.map" >> /usr/share/texlive/texmf-dist/web2c/updmap.cfg \
   && mktexlsr \
   && updmap-sys

## Install Pandoc
RUN mkdir -p /opt/pandoc \
  && wget --no-check-certificate -O /tmp/pandoc.zip https://s3.amazonaws.com/rstudio-buildtools/pandoc-1.13.1.zip \
  && unzip -j /tmp/pandoc.zip "pandoc-1.13.1/linux/debian/x86_64/pandoc" -d /opt/pandoc \
  && chmod +x /opt/pandoc/pandoc \
  && ln -s /opt/pandoc/pandoc /usr/local/bin \
  && unzip -j /tmp/pandoc.zip "pandoc-1.13.1/linux/debian/x86_64/pandoc-citeproc" -d /opt/pandoc \
  && chmod +x "/opt/pandoc/pandoc-citeproc" \
  && ln -s "/opt/pandoc/pandoc-citeproc" /usr/local/bin \
  && rm -f /tmp/pandoc.zip

## Install knitr and pander packages
RUN install2.r --error \
    knitr \
    pander \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

CMD /bin/bash
