ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION

LABEL maintainer="Pankaj Aagjal"
LABEL description="Lightweight curl pre-installed Alpine image"
LABEL version="${ALPINE_VERSION}"

RUN apk add --no-cache curl

RUN addgroup -g 1000 curluser && \
    adduser -D -s /bin/sh -u 1000 -G curluser curluser

WORKDIR /data

RUN chown -R curluser:curluser /data

USER curluser