ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION

LABEL maintainer="Pankaj Aagjal"
LABEL description="Lightweight yq pre-installed Alpine image"
LABEL version="${ALPINE_VERSION}"

RUN apk add --no-cache yq

RUN addgroup -g 1000 yquser && \
    adduser -D -s /bin/sh -u 1000 -G yquser yquser

WORKDIR /data

RUN chown -R yquser:yquser /data

USER yquser