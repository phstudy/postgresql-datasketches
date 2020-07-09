FROM postgres:9.6

MAINTAINER Study Hsueh <ph.study@gmail.com>

ENV PG_MAJOR 9.6
ENV DATASKETCHES_VERSION 1.3.0

RUN echo "===> Adding prerequisites..."                      && \
    apt-get update -y                                        && \
    DEBIAN_FRONTEND=noninteractive                              \
        apt-get install --no-install-recommends --allow-downgrades -y -q \
                ca-certificates                                 \
                build-essential wget unzip                      \
                postgresql-server-dev-9.6                       \
                libpq-dev=$PG_MAJOR\* libpq5=$PG_MAJOR\* libecpg-dev     && \
    echo "===> Building datasketches..."                     && \
    wget http://api.pgxn.org/dist/datasketches/$DATASKETCHES_VERSION/datasketches-$DATASKETCHES_VERSION.zip && \
    unzip datasketches-$DATASKETCHES_VERSION.zip             && \
    wget https://github.com/apache/incubator-datasketches-postgresql/commit/fc35848a683130555bb0813afa47e4ddc6c9ba97.patch && \
    patch -d datasketches-$DATASKETCHES_VERSION -p1 <fc35848a683130555bb0813afa47e4ddc6c9ba97.patch && \
    cd datasketches-$DATASKETCHES_VERSION                    && \
    make                                                     && \
    make install                                             && \
    \
    \
    echo "===> Clean up..."                                  && \
    apt-get -y remove --purge --auto-remove                     \
            ca-certificates                                     \
            build-essential wget unzip                          \
            postgresql-server-dev-$PG_MAJOR libpq-dev libecpg-dev  && \
    apt-get clean                                            && \
    rm -rf datasketches-$DATASKETCHES_VERSION /var/lib/apt/lists/* /tmp/* /var/tmp/* fc35848a683130555bb0813afa47e4ddc6c9ba97.patch

ADD /docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 5432
CMD ["postgres"]