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
 && [ "$SDK_ARCH" != arm ] \
 || exit 0 \
 && DART_SDK_CACHE="$HOME/.dart/dartdev/sdk_cache/$(cat "$DART_SDK/version")" \
 && mkdir -p "$DART_SDK_CACHE" \
 && cd "$DART_SDK_CACHE" \
 && find /build \( -name "dartaotruntime_*" -o -name "gen_snapshot_linux_${SDK_ARCH}_*" \) -not -name "dartaotruntime_linux_${SDK_ARCH}" -not -name "gen_snapshot_linux_${SDK_ARCH}_linux_${S
DK_ARCH}" -print0 | xargs -0 -n 1 -- sh -c 'cp "$1" "$(basename "$1")" && chmod a+x "$(basename "$1")"' --
