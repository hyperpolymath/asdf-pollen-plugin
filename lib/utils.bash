#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail

TOOL_NAME="pollen"
BINARY_NAME="pollen"

fail() { echo -e "\e[31mFail:\e[m $*" >&2; exit 1; }

list_all_versions() {
  # Pollen versions from pkgs.racket-lang.org
  echo "4.0" "3.2" "3.1" "3.0" "2.2" "2.1" "2.0" | tr ' ' '\n' | sort -V
}

download_release() {
  local version="$1" download_path="$2"
  mkdir -p "$download_path"
  echo "$version" > "$download_path/VERSION"
}

install_version() {
  local install_type="$1" version="$2" install_path="$3"

  command -v raco >/dev/null || fail "Racket (raco) not found. Install Racket first."

  mkdir -p "$install_path/bin"
  raco pkg install --auto pollen || fail "raco pkg install failed"

  # Link pollen command
  local raco_bin="$(dirname "$(command -v raco)")"
  if [[ -f "$raco_bin/pollen" ]]; then
    ln -sf "$raco_bin/pollen" "$install_path/bin/pollen"
  fi
}
