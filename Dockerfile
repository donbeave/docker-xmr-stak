FROM alpine:3.7

RUN echo $PATH

RUN set -ex \
    && echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && mkdir /data \
    && addgroup -S miner \
    && adduser -D -S -h /data -s /sbin/nologin -G miner miner \
    && apk upgrade --no-cache \
    && apk add --no-cache \
           openssl-dev \
           libmicrohttpd-dev \
           coreutils \
           cmake \
           g++ \
           build-base \
           git \
           hwloc-dev@testing \
    && git clone https://github.com/fireice-uk/xmr-stak \
    && cd xmr-stak \
    && cmake . -DCMAKE_LINK_STATIC=ON -DXMR-STAK_COMPILE=generic -DCPU_ENABLE=ON -DHWLOC_ENABLE=ON -DMICROHTTPD_ENABLE=ON -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF \
    && make -j$(nproc) \
    && cp bin/xmr-stak /usr/local/bin/ \
    && apk del --no-cache --purge --force \
           hwloc-dev \
           openssl-dev \
           libmicrohttpd-dev \
           coreutils \
           cmake \
           g++ \
           build-base \
           git \
    && rm -rf xmr-stak

RUN apk add --no-cache \
        libmicrohttpd \
        openssl \
        hwloc@testing

RUN echo $PATH

VOLUME /data

WORKDIR /data

USER miner

CMD ["xmr-stak"]
