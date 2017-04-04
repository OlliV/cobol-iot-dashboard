FROM debian:jessie AS base
RUN apt-get update && apt-get -y install libcob1 libhiredis0.10

FROM base AS build-base
RUN apt-get -y install make gcc

FROM build-base AS build-cobol
RUN apt-get -y install open-cobol libhiredis-dev && \
    mkdir -p /usr/src
WORKDIR /usr/src
COPY Makefile   /usr/src
COPY src-c      /usr/src/src-c
COPY src-cbl    /usr/src/src-cbl
RUN make

FROM build-base AS build-klange
RUN mkdir -p /usr/src/klange
WORKDIR /usr/src/klange
COPY klange /usr/src/klange
RUN make

FROM base
RUN apt-get -y autoremove && \
    echo 'Yes, do as I say!' | apt-get remove -y --force-yes --purge \
    passwd python2.7 mount sysv-rc sysvinit-utils udev e2fslibs e2fsprogs login python \
    gzip bsdutils apt || \
    rm -rf /var/cache/apt /usr/share /usr/lib/python2.7 /sbin

RUN mkdir -p /var/www
COPY --from=build-cobol /usr/src/the.cow /var/www/the.cow
COPY --from=build-klange /usr/src/klange/cgiserver /usr/bin/cgiserver
COPY views /var/www/views
WORKDIR /var/www

EXPOSE 3000
CMD ["cgiserver"]
