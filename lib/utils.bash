#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/operator-framework/operator-registry"
OCP_PREFIX="openshift-"
OCP_V4_REPO="https://mirror.openshift.com/pub/openshift-v4"
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

get_platform() {
  local platform
  platform="$(uname -s)"
  #Convert to lowercase
  platform="${platform,,}"
  #Some environments expose version among hardvare platform (e.g. MINGW32_NT-6.1)
  #So check only prefix
  case "${platform}" in
    linux*|mingw*|cygwin*) echo linux;;
    darwin*) echo darwin;;
    *) echo "unsupported_platform_${platform}";;
  esac
}

get_arch() {
  local arch
  arch="$(uname -m)"
  arch="${arch,,}"
  case "${arch}" in
    x86_64) echo amd64;;
    arm64) echo arm64;;
    s390x) echo s390x;;
    ppc64le) echo ppc64le;;
    *) echo "unsupported_arch_${arch}";;
  esac
}

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_openshift_releases() {
  local arch
  arch="$(get_arch)"
  curl -LSsq "${OCP_V4_REPO}/${arch}/clients/ocp/" |
    #opm in openshift supported in 4.7+
    awk -F '[<>]' -v ocp_prefix="${OCP_PREFIX}" '
      /span[[:space:]]{1,}class="name"/{
        split($3, a, ".");
        if (a[2] >= 7){
          print ocp_prefix$3
        }
      }'
}

list_all_versions() {
  list_github_tags
  list_openshift_releases
}

download_release() {
  local platform arch
  local version="$1"
  local filename="$2"
  platform="$(get_platform)"
  arch="$(get_arch)"
  case "${version}" in
    ${OCP_PREFIX}*) local url="${OCP_V4_REPO}/${arch}/clients/ocp/${version/"${OCP_PREFIX}"/}/opm-${platform/dawin/mac}.tar.gz";;
    *) local url="$GH_REPO/releases/download/v${version}/${platform}-${arch}-opm";;
  esac

  echo "* Downloading $TOOL_NAME release $version for platform ${platform} (${arch})..."
  curl "${curl_opts[@]}" -o "$filename" -- "$url" || fail "Could not download $url"
  case "${url}" in
    *.tar.gz)
      mv "${filename}" "${filename}.tar.gz"
      tar -C "$(dirname -- "${filename}")" -xzf "${filename}.tar.gz"
      rm -f "${filename}.tar.gz";;
  esac
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
