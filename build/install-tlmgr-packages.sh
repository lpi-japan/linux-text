#!/bin/bash
# pandoc/extra に無い TeX パッケージを tlmgr で追加する。
set -euo pipefail

readonly PACKAGES=(collection-langjapanese tocloft wallpaper eso-pic)
# tlnet ミラー（上ほど固定 URL・下ほど live に近い）。
readonly REPOS=(
  "https://latex.us/systems/texlive/tlnet"
  "https://mirrors.mit.edu/CTAN/systems/texlive/tlnet"
  "https://mirror.ctan.org/systems/texlive/tlnet"
)

all_installed() {
  local pkg
  for pkg in "${PACKAGES[@]}"; do
    tlmgr info --only-installed "$pkg" 2>/dev/null | grep -q 'installed:   Yes' || return 1
  done
}

if all_installed; then
  echo "tlmgr: required packages already installed"
  exit 0
fi

echo "tlmgr: installing ${PACKAGES[*]}"

for repo in "${REPOS[@]}"; do
  echo "tlmgr: repository=${repo} install"
  tlmgr option repository "${repo}"
  tlmgr install "${PACKAGES[@]}" || true
  all_installed && exit 0
done

for repo in "${REPOS[@]}"; do
  echo "tlmgr: repository=${repo} update --self + install"
  tlmgr option repository "${repo}"
  tlmgr update --self || true
  tlmgr install "${PACKAGES[@]}" || true
  all_installed && exit 0
done

echo "tlmgr: install failed for: ${PACKAGES[*]}" >&2
exit 1
