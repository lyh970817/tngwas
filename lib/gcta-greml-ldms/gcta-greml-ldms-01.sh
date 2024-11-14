#!/bin/bash
set -e

export OUT_GCTA="$OUT/gcta_grm"

GEN_BASE_NAMES=($(getnames_nosuf $GEN/*))

rm -f "$TMP/gcta_grm_bfiles.list"
for name in "${GEN_BASE_NAMES[@]}"; do
	echo "$GEN/$name" >>"$TMP/gcta_grm_bfiles.list"
done
