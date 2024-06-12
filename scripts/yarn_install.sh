#!/usr/bin/env bash
#
# install yarn node package manager manager using corepack

if ! command -v corepack 2>&1 >/dev/null; then
    echo "Yarn installation requires Node.js with corepack. See https://yarnpkg.com/getting-started/install"
    exit 1
fi

corepack enable
yarn init -2 --yes

