#!/bin/bash
set -e

export OUT_GCTA="$OUT/gcta_grm"
gen_path_array_id=$(eval echo $GEN_PATH)
gen_out_path_array_id=$(eval echo $GEN_OUT_PATH)

$GCTA \
	--bfile $gen_path_array_id \
	--ld-score-region 200 \
	--out ${gen_out_path_array_id}_gcta_ld \
	--thread-num $CPUS_OPENMP

Rscript $PIPE/segment_snp.R ${gen_out_path_array_id}_gcta_ld.score.ld $OUT_GCTA
