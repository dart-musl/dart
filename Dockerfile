FROM alpine:3

ARG BASEURL

ENV DART_SDK /usr/lib/dart
ENV PATH $DART_SDK/bin:$PATH

RUN apk add --no-cache \
            ca-certificates \
            curl \
            git \
            openssh-client \
 && case "$(cat /etc/apk/arch)" in \
      x86_64) \
        SDK_ARCH=x64;; \
      x86) \
        SDK_ARCH=ia32;; \
      aarch64) \
        SDK_ARCH=arm64;; \
      armv7) \
        SDK_ARCH=arm;; \
    esac \
 && wget -O- "$BASEURL/dartsdk-linux-$SDK_ARCH-release.tar.gz" \
  | tar -xz \
 && mv dart-sdk "$DART_SDK"
