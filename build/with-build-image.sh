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

GIT_META="${GIT_METADATA:-$("${BUILD_DIR}/git-metadata.sh" "${ROOT_DIR}" 2>/dev/null || true)}"

exec docker run --rm -i \
  -e LC_ALL=C.UTF-8 \
  -e GIT_METADATA="${GIT_META}" \
  -v "${ROOT_DIR}:/data" \
  -w /data \
  --entrypoint /bin/bash \
  "${IMAGE}" -lc "$*"
