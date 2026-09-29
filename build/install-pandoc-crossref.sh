#!/bin/bash
# pandoc/extra 同梱の pandoc-crossref は Pandoc 版とずれることがある。
# v0.3.24a (Pandoc 3.9.0.2 ビルド) を明示的に入れて揃える。
set -euo pipefail

readonly VERSION=v0.3.24a
readonly URL="https://github.com/lierdakil/pandoc-crossref/releases/download/${VERSION}/pandoc-crossref-Linux-X64.tar.xz"

tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT

curl -fsSL -o "${tmpdir}/pandoc-crossref.tar.xz" "${URL}"
tar -xJf "${tmpdir}/pandoc-crossref.tar.xz" -C /usr/local/bin pandoc-crossref
chmod +x /usr/local/bin/pandoc-crossref

echo "pandoc: $(pandoc --version | head -1)"
pandoc-crossref --version | head -1
