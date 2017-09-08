#!/usr/bin/env bash
#
# instructions from https://github.com/cloudflare/cfssl#installation
#
# run it like `cfssl certinfo -domain beta.lilt.com`

quiet()
{ "$@" >/dev/null 2>&1; }

go get -u github.com/cloudflare/cfssl/cmd/...
if quiet command -v cfssl
then
  echo "cfssl install: success"
fi
