#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/operator-framework/operator-registry"
TOOL_NAME="opm"
TOOL_TEST="opm --help"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

get_platform() {
  local platform
  platform="$(uname -s | tr '[:upper:]' '[:lower:]')"
  #Some environments expose version among OS platform (e.g. MINGW32_NT-6.1)
  #So check only prefix
  case "${platform}" in
    linux*|mingw*|cygwin*) echo linux;;
    darwin*) echo darwin;;
    *) echo "unsupported_platform_${platform}";;
  esac
}

get_arch() {
  local arch
  arch="$(uname -m | tr '[:upper:]' '[:lower:]')"
  case "${arch}" in
    x86_64) echo amd64;;
    arm64) echo arm64;;
    s390x) echo s390x;;
    ppc64le) echo ppc64le;;
    *) echo "unsupported_arch_${arch}";;
  esac
}

download_release() {
  local version filename url platform arch
  version="$1"
  filename="$2"
  platform="$(get_platform)"
  arch="$(get_arch)"

  url="$GH_REPO/releases/download/v${version}/${platform}-${arch}-opm"

  echo "* Downloading $TOOL_NAME release $version for platform ${platform} (${arch})..."
  curl "${curl_opts[@]}" -o "$filename" -- "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
