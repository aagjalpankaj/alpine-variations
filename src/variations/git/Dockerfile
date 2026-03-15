ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

ARG ALPINE_VERSION

LABEL maintainer="Pankaj Aagjal"
LABEL description="Lightweight git pre-installed Alpine image"
LABEL version="${ALPINE_VERSION}"

RUN apk add --no-cache git

RUN addgroup -g 1000 gituser && \
    adduser -D -s /bin/sh -u 1000 -G gituser gituser

WORKDIR /data

RUN chown -R gituser:gituser /data

USER gituser