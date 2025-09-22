FROM alpine:3.18

RUN apk update && \
    apd add --no-cache aws-cli rancid openssh

RUN if ! id rancid > /dev/null 2>&1; then \
        addgroup -S rancid && \
        adduser -S -D -H -h /var/lib/rancid - G rancid rancid && \
        echo "rancid:rancid" | chpasswd; \
    fi

WORKDIR /

RUN mkdir -p /var/lib/rancid \
    && mkdir -p /home/rancid/var/routers \
    && chown - R rancid /var/lib/rancid /home/rancid /home/rancid/var

COPY rancid.conf /etc/rancid
COPY .cloginrc /var/rancid
RUN chown -R rancid /var/rancid/.cloginrc
COPY router.db /home/rancid/var/routers

COPY entrypoint.sh
RUN chmodx +x entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]