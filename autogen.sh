#!/bin/sh
set -e
mkdir -p build-aux m4
autoreconf --force --install --verbose
