#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${BUILD_DIR}/.." && pwd)"
# shellcheck source=git-metadata.sh
source "${BUILD_DIR}/git-metadata.sh"
OUT_DIR="${ROOT_DIR}/tmp"
VER="$(grep -oP 'Ver\.\d+\.\d+\.\d+' "${ROOT_DIR}/config-pdf.yaml" | head -1 | sed 's/^Ver\.//')"
OUTPUT_PDF="${OUT_DIR}/linuxtext_${VER}.pdf"
OUTPUT_NO_COVER="${OUT_DIR}/linuxtext_${VER}_no_cover.pdf"

# cover | no-cover | all（省略時は all。ローカル一括用）
MODE="${1:-all}"
case "${MODE}" in
  cover|no-cover|all) ;;
  *)
    echo "usage: $0 [cover|no-cover|all]" >&2
    exit 2
    ;;
esac

if ! command -v pandoc >/dev/null 2>&1 || ! command -v lualatex >/dev/null 2>&1; then
  exec "${BUILD_DIR}/with-build-image.sh" "./build/build-pdf.sh ${MODE}"
fi

mkdir -p "${OUT_DIR}"

chapters=()
while IFS= read -r -d '' f; do
  chapters+=("$(basename "${f}")")
done < <(find "${ROOT_DIR}" -maxdepth 1 -type f -name 'Chapter*.md' ! -name 'Chapter00.md' -print0 | LC_ALL=C sort -z)

if ((${#chapters[@]} == 0)); then
  echo "no chapter markdown files found" >&2
  exit 1
fi

build_one() {
  local no_cover="$1"
  local output="$2"
  local -a extra=()
  if [[ "${no_cover}" == "1" ]]; then
    extra=(-M no-cover=true)
  fi
  if meta="$(git_build_metadata "${ROOT_DIR}" 2>/dev/null)"; then
    extra+=(-M "keywords=${meta}")
  fi
  pandoc Chapter00.md -o preface.tex
  pandoc -d config-pdf.yaml --template build/template.tex -B preface.tex "${chapters[@]}" \
    "${extra[@]}" -o "${output}"
  rm -f preface.tex
  echo "Output: ${output}"
  ls -lh "${output}"
}

(
  cd "${ROOT_DIR}"
  case "${MODE}" in
    cover)
      build_one 0 "${OUTPUT_PDF}"
      ;;
    no-cover)
      build_one 1 "${OUTPUT_NO_COVER}"
      ;;
    all)
      build_one 0 "${OUTPUT_PDF}"
      build_one 1 "${OUTPUT_NO_COVER}"
      ;;
  esac
)
