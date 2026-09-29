#!/usr/bin/env bash
# Emit Pandoc metadata value for the current Git revision (not written into source YAML).
# PDF: pass as -M "keywords=..." (hyperref → PDF Info, not visible on pages).
# EPUB: pass as -M "description=..." (OPF metadata, not shown in normal reading view).
#
# Prefer GIT_METADATA (e.g. from GitHub Actions or docker -e) so the build never
# needs to run git inside a container. A 40-char SHA is trimmed to 12 chars.
set -euo pipefail

git_build_metadata() {
  if [[ -n "${GIT_METADATA:-}" ]]; then
    # Normalize git=<40-hex-sha>[suffix] → git=<12-hex-sha>[suffix]
    if [[ "${GIT_METADATA}" =~ ^git=([0-9a-f]{12})[0-9a-f]{28}(.*)$ ]]; then
      printf 'git=%s%s' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    else
      printf '%s' "${GIT_METADATA}"
    fi
    return 0
  fi
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
