#!/usr/bin/env bash
# Host にビルド用ツールチェーンが無いとき、イメージ内で COMMAND を再実行する。
set -euo pipefail

BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${BUILD_DIR}/.." && pwd)"
IMAGE="${TEXT_IMAGE:-ghcr.io/lpi-japan/linux-text:local}"

if ! docker image inspect "${IMAGE}" >/dev/null 2>&1; then
  echo "Building image: ${IMAGE}" >&2
  docker build -f "${BUILD_DIR}/Dockerfile" -t "${IMAGE}" "${BUILD_DIR}"
fi

exec docker run --rm -i \
  -e LC_ALL=C.UTF-8 \
  -v "${ROOT_DIR}:/data" \
  -w /data \
  --entrypoint /bin/bash \
  "${IMAGE}" -lc "$*"
