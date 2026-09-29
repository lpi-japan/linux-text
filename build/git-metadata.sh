#!/usr/bin/env bash
# Emit Pandoc metadata value for the current Git revision (not written into source YAML).
# PDF: pass as -M "keywords=..." (hyperref → PDF Info, not visible on pages).
# EPUB: pass as -M "description=..." (OPF metadata, not shown in normal reading view).
set -euo pipefail

git_build_metadata() {
  local root="${1:?repo root}"
  if ! git -C "${root}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return 1
  fi
  local sha suffix=""
  sha="$(git -C "${root}" rev-parse --short=12 HEAD)"
  if ! git -C "${root}" diff --quiet --ignore-submodules \
    || ! git -C "${root}" diff --cached --quiet --ignore-submodules; then
    suffix="-dirty"
  fi
  printf 'git=%s%s' "${sha}" "${suffix}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  git_build_metadata "$(cd "$(dirname "$0")/.." && pwd)"
fi
