#!/usr/bin/env nix-shell
#!nix-shell -p lftp -i bash

set -e
set -u

HOST="$1"

result=$(NIX_PATH= nix-build -A sdcard-filesystem)
echo "mirror --no-perms --reverse --verbose ${result} /" | lftp "$HOST"
