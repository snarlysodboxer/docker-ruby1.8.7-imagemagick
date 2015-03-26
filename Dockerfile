# vi: ft=config
FROM ubuntu:12.04
MAINTAINER david amick <docker@davidamick.com>

ENV DEBIAN_FRONTEND noninteractive

RUN /bin/bash -c "apt-get update -qq && apt-get install -qy wget curl bzip2 make gcc build-essential patch zlib1g-dev libssl-dev libreadline-gplv2-dev libxml2 libxml2-dev libxslt1-dev nodejs postgresql-contrib libpq-dev git-core && apt-get clean"

RUN wget -O ghostscript-9.15.tar.gz http://downloads.ghostscript.com/public/ghostscript-9.15.tar.gz && tar -xzvf ghostscript-9.15.tar.gz && rm ghostscript-9.15.tar.gz
RUN cd ghostscript-9.15 && ./configure --enable-dynamic
RUN cd ghostscript-9.15 && make install

RUN /bin/bash -c "apt-get update -qq && apt-get install -qy liblcms2-2 liblcms2-dev liblcms2-utils webp librsvg2-dev librsvg2-2 librsvg2-bin liblqr-1-0-dev liblqr-1-0 libopenexr6 libopenexr-dev exrtools openexr fontconfig libfontconfig1-dev libfontconfig1 libwmf-dev libwmf-bin libtiff4 libtiff4-dev libtiff-tools libtiff-opengl libpng12-0 libpng12-dev libpng3 && apt-get clean"
RUN /bin/bash -c "apt-get update -qq && apt-get install -qy libfreetype6-dev libfreetype6"

RUN wget -O ImageMagick.tar.gz http://www.imagemagick.org/download/ImageMagick.tar.gz && tar xzvf ImageMagick.tar.gz && rm ImageMagick.tar.gz
RUN cd ImageMagick-6.9.1-0 && ./configure && make install
RUN cd ImageMagick-6.9.1-0 && make check
RUN ldconfig /usr/local/lib

RUN wget -O ruby-enterprise-1.8.7-2012.02.tar.gz http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-1.8.7-2012.02.tar.gz && tar -xzvf ruby-enterprise-1.8.7-2012.02.tar.gz && rm ruby-enterprise-1.8.7-2012.02.tar.gz
RUN sed -i'' "1672s/.*/void \*(\* volatile __memalign_hook)(size_t, size_t, const void \*) = MemalignOverride\;/" ruby-enterprise-1.8.7-2012.02/source/distro/google-perftools-1.7/src/tcmalloc.cc
RUN ./ruby-enterprise-1.8.7-2012.02/installer --auto /usr/local --dont-install-useful-gems --no-dev-docs
ENV PATH /usr/local/bin:$PATH
RUN gem install bundler --no-ri --no-rdoc


ENTRYPOINT ["/bin/bash"]
CMD ["-l"]
