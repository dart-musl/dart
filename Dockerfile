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
 && echo x64 arm64 arm riscv64 | xargs -n 1 sh -c 'if [ "$1" != arm ] && [ "$1" != "$2" ]; then cp "/build/dartaotruntime_linux_$2" . && chmod a+x "dartaotruntime_linux_$2" && cp "/build/gen_snapshot_linux_$1_linux_$2" && chmod a+x "gen_snapshot_linux_$1_linux_$2"; fi' -- "$SDK_ARCH"
