FROM docker.io/library/alpine

ENV DART_SDK=/usr/lib/dart
ENV PATH=$DART_SDK/bin:$PATH

RUN --mount=type=bind,source=.,target=/build \
    apk add --no-cache \
            ca-certificates \
            curl \
            git \
            openssh-client \
 && case "$(apk --print-arch)" in \
      x86_64) \
        SDK_ARCH=x64;; \
      aarch64) \
        SDK_ARCH=arm64;; \
      armv7) \
        SDK_ARCH=arm;; \
      riscv64) \
        SDK_ARCH=riscv64;; \
    esac \
 && tar -xzf /build/dartsdk-linux-$SDK_ARCH-release.tar.gz \
 && mv dart-sdk "$DART_SDK"
