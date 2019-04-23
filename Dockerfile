FROM golang:1.12.4-stretch AS goimage

ENV IMAGEMAGICK_VERSION 7.0.8-41
ENV DEP_VERSION 0.5.1

ENV CGO_CFLAGS_ALLOW='-Xpreprocessor'
ENV PKG_CONFIG_PATH=/usr/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib/

RUN apt-get update && apt-get -y install \
	build-essential \
	ca-certificates \
	curl \
	git \
	bash \
	file \
	libgeoip-dev \
	libmaxminddb-dev \
 	libpng-dev \
	libjpeg-dev \
	libwebp-dev \
	libexif-dev \
	liblzma-dev \
	libtiff-dev \
	libopenjp2-7-dev \
	liblcms2-dev \
	libxml2-dev \
	zlib1g-dev \
	libjpeg62-turbo-dev \
	libmagickwand-dev \
	make \
	wget \
	sed \
	bash 

WORKDIR /usr/local/src

RUN wget https://github.com/ImageMagick/ImageMagick/archive/${IMAGEMAGICK_VERSION}.tar.gz && \
	tar -xvf ${IMAGEMAGICK_VERSION}.tar.gz && \
	cd ImageMagick-7.* && \
	./configure \
	--prefix=/usr \
	--enable-shared \
	--disable-openmp \
	--disable-hdri \
	--disable-largefile \
	--disable-static \
	--with-bzlib \
	--with-jpeg \
	--with-webp \
	--with-jp2 \
	--with-lcms \
	--with-png \
	--with-tiff \
	--with-webp \
	--with-xml \
	--with-zlib \
	--with-quantum-depth=8 \
	--without-dot \
	--without-dps \
	--without-fpx \
	--without-freetype \
	--without-gslib \
	--without-magick-plus-plus \
	--without-perl \
	--without-wmf \
	--without-x \
	&& \
	make && \
	make install && \
	ldconfig /usr/local/lib

RUN curl -fsSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/v${DEP_VERSION}/dep-linux-amd64 \
	&& \
	chmod +x /usr/local/bin/dep

RUN pkg-config --cflags  -- MagickWand MagickCore MagickWand MagickCore

WORKDIR /

RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /usr/local/src

CMD [ "bash" ]
