#!/usr/bin/env bash

set -x
set -eo pipefail

. .github/workflows/common.sh

get_key() {
	local key=$1
	local server=$2
	gpg --batch --keyserver "${server}" --recv-keys "${key}"
	echo -e "${key}:6:" | gpg --import-ownertrust
}

# verify signature
keys=( 7D1E8AFD1D4A16D71FADA2F2CCC85C0E40C06A8C )
for key in "${keys[@]}" ; do
	get_key "${key}" keys.openpgp.org || get_key "${key}" keyserver.ubuntu.com
done
unset key
gpg --verify "${METADATA_FILE}.sig"
