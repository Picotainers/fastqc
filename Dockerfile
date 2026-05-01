# syntax=docker/dockerfile:1

FROM debian:bookworm AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ant \
        ca-certificates \
        git \
        openjdk-17-jdk-headless \
        perl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
ARG FASTQC_TAG=v0.12.1
RUN git clone --depth 1 --branch ${FASTQC_TAG} https://github.com/s-andrews/FastQC.git fastqc \
    && cd fastqc \
    && ant cleanall build \
    && chmod +x bin/fastqc \
    && install -d /out/opt/fastqc /out/usr/local/bin \
    && cp -a bin/. /out/opt/fastqc/ \
    && printf '%s\n' \
        '#!/bin/sh' \
        'set -eu' \
        'if [ "${1:-}" = "fastqc" ]; then shift; fi' \
        'exec /opt/fastqc/fastqc "$@"' \
      > /out/usr/local/bin/fastqc \
    && chmod +x /out/usr/local/bin/fastqc

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        openjdk-17-jre-headless \
        perl \
        unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /out/ /
WORKDIR /data

ENTRYPOINT ["/usr/local/bin/fastqc"]
CMD ["--help"]
