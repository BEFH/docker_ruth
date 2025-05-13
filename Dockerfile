FROM alpine:3.21
RUN mkdir setup
RUN apk add --no-cache g++ gcc make cmake bzip2-dev zlib-dev ncurses-dev \
  xz-dev autoconf automake curl-dev openssl-dev git wget bash sed
WORKDIR /setup
RUN wget https://github.com/samtools/htslib/releases/download/1.21/htslib-1.21.tar.bz2 && \
  tar -xf htslib-1.21.tar.bz2 && \
  cd htslib-1.21/ && \
  autoreconf -i && \
  ./configure && \
  make && \
  make install && \
  cd .. && \
  rm -rf htslib-1.21
RUN git clone https://github.com/statgen/ruth.git && \
  cd ruth && mkdir build && \
  sed -i '/^#pragma once/i #include <cstdint>' Error.h && \
  cd build && \
  cmake .. && \
  make && \
  cd .. && \
  cp bin/ruth /usr/local/bin/ && \
  cd .. && \
  rm -rf ruth
WORKDIR /
RUN rm -rf setup
ENTRYPOINT ["ruth"]
