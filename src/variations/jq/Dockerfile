ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION

LABEL maintainer="Pankaj Aagjal"
LABEL description="Lightweight jq pre-installed Alpine image"
LABEL version="${ALPINE_VERSION}"

RUN apk add --no-cache jq

RUN addgroup -g 1000 jquser && \
    adduser -D -s /bin/sh -u 1000 -G jquser jquser

WORKDIR /data

RUN chown -R jquser:jquser /data

USER jquser
