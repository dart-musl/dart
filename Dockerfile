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
 && mv dart-sdk "$DART_SDK" \
 && DART_SDK_CACHE="$HOME/.dart/$(cat "$DART_SDK/version")" \
 && mkdir -p "$DART_SDK_CACHE" \
 && cd "$DART_SDK_CACHE" \
 && echo x64 arm64 arm riscv64 | xargs -n 1 sh -c 'if [ "$1" != "$2" ]; then tar -xzf /build/dartsdk-linux-$2-release.tar.gz --strip-components 2 -- dart-sdk/bin/dartaotruntime && mv dartaotruntime dartaotruntime_linux_$2 && if [ "$1" != arm ]; then tar -xzf /build/dartsdk-linux-$1-linux-$2-release.tar.gz --strip-components 3 -- dart-sdk/bin/utils/gen_snapshot && mv gen_snapshot gen_snapshot_linux_$1_linux_$2; fi; fi' -- $SDK_ARCH
