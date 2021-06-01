FROM alpine:3.13
LABEL maintainer="Pedro Sanders <psanders@fonoster.com>"

# TODO: Update to use Asterisk 16 instead of 18.
# Asterisk 18 breaks the externalMedia functionality

COPY config /etc/asterisk/
COPY run.sh /

RUN apk add --no-cache --update \
 curl \
 tini \
 asterisk \
 asterisk-sounds-en \
 npm \
 nodejs \
 python3 \ 
 && npm -g config set user root \  
 && npm -g install @fonos/dispatcher \
 && chmod +x /run.sh

ENTRYPOINT ["tini", "-v", "--"]
CMD ["/run.sh"]

HEALTHCHECK CMD curl -u "${ARI_USERNAME}:${ARI_SECRET}" --fail  http://localhost:8088/ari/asterisk/ping || exit 1