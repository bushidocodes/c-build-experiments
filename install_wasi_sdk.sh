#!/bin/bash
# Check https://github.com/WebAssembly/wasi-sdk/releases for the latest version
VERSION=33
ARCH=x86_64
wget "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${VERSION}/wasi-sdk-${VERSION}.0-${ARCH}-linux.tar.gz"
tar xvf "wasi-sdk-${VERSION}.0-${ARCH}-linux.tar.gz"
rm "wasi-sdk-${VERSION}.0-${ARCH}-linux.tar.gz"
mv "wasi-sdk-${VERSION}.0-${ARCH}-linux" "wasi-sdk-${VERSION}.0"
