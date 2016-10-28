FROM 5003/builder:curl
RUN addgroup -S kibana && adduser -S -D -G kibana kibana

COPY docker-entrypoint.sh /usr/local/bin/
RUN apk add --no-cache --virtual .builder tar && \
    apk add --no-cache su-exec \
                       nodejs-lts \
                       tini && \
    mkdir /usr/share/kibana/ && curl --location https://artifacts.elastic.co/downloads/kibana/kibana-5.0.0-linux-x86_64.tar.gz \
    | tar --gzip --extract --file - --directory /usr/share/kibana/ --strip-components 1 && \
    apk del --no-cache .builder && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

RUN rm -r /usr/share/kibana/node/ && \
    mkdir -p /usr/share/kibana/node/bin/ && \
    ln -s $(which node) /usr/share/kibana/node/bin/node && \
    chown --recursive kibana:kibana /usr/share/kibana/config/ \
                                    /usr/share/kibana/optimize/

ENV PATH /usr/share/kibana/bin:$PATH

EXPOSE 5601
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["kibana"]