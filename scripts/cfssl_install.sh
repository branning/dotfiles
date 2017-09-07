#!/usr/bin/env bash
#
# instructions from https://github.com/cloudflare/cfssl#installation
#
# run it like `cfssl certinfo -domain beta.lilt.com`

go get -u github.com/cloudflare/cfssl/cmd/cfssl
if command -v cfssl
then
  "cfssl install: success"
fi
