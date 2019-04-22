FROM golang:1.12.4-stretch AS goimage

RUN export CGO_CFLAGS_ALLOW='-Xpreprocessor'
RUN export PKG_CONFIG_PATH=/usr/lib/pkgconfig
RUN export LD_LIBRARY_PATH=/usr/lib/

RUN apt-get update && \
	apt-get -y install \
	ca-certificates \
	curl \
	git \
	bash \
	file \
    libgeoip-dev \
	libmaxminddb-dev \
	libwebp-dev \
    libpng-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
	imagemagick \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /usr/local/bin/dep https://github.com/golang/dep/releases/download/v0.5.1/dep-linux-amd64 \
	&& \
	chmod +x /usr/local/bin/dep

RUN pkg-config --cflags  -- MagickWand MagickCore MagickWand MagickCore
