#!/bin/bash
set -euo pipefail
# Check https://github.com/WebAssembly/wasi-sdk/releases for the latest version
# To update: bump VERSION and set SHA256 from:
#   gh api "repos/WebAssembly/wasi-sdk/releases/tags/wasi-sdk-${VERSION}" \
#     --jq '.assets[] | select(.name == "wasi-sdk-${VERSION}.0-${ARCH}-linux.tar.gz") | .digest'
VERSION=33
ARCH=x86_64
TARBALL="wasi-sdk-${VERSION}.0-${ARCH}-linux.tar.gz"
SHA256="0ba8b5bfaeb2adf3f29bab5841d76cf5318ab8e1642ea195f88baba1abd47bce"

wget "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${VERSION}/${TARBALL}"
echo "${SHA256}  ${TARBALL}" | sha256sum -c -
tar xf "${TARBALL}"
rm "${TARBALL}"
mv "wasi-sdk-${VERSION}.0-${ARCH}-linux" "wasi-sdk-${VERSION}.0"
