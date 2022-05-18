FROM curlimages/curl:latest

ARG TARGETPLATFORM

RUN export ARCH=$(case ${TARGETPLATFORM:-linux/arm64} in \
    "linux/arm/v7")  echo "armv7"   ;; \
    "linux/arm64")   echo "aarch64" ;; \
    *)               echo ""        ;; esac); \
    curl -L https://github.com/getsentry/sentry-cli/releases/latest/download/sentry-cli-Linux-${ARCH} > /tmp/sentry-cli; \
    chmod +x /tmp/sentry-cli

FROM alpine:3.14

RUN apk add --no-cache ca-certificates

COPY --from=0 /tmp/sentry-cli /bin/sentry-cli

WORKDIR /work
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]