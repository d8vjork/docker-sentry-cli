FROM alpine:3.14
ARG TARGETPLATFORM

RUN apk add --no-cache ca-certificates

RUN export ARCH=$(case ${TARGETPLATFORM:-linux/arm64} in \
    "linux/arm/v7")  echo "armv7"   ;; \
    "linux/arm64")   echo "aarch64" ;; \
    *)               echo ""        ;; esac)
ADD https://github.com/getsentry/sentry-cli/releases/latest/download/sentry-cli-Linux-${ARCH} /bin/sentry-cli

RUN chmod +x /bin/sentry-cli

WORKDIR /work
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]