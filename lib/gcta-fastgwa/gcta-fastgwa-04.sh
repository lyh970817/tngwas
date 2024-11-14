#!/bin/bash
set -e

export OUT_GCTA="$OUT/gcta_grm"
export QCOV_GCTA="$TMP/qcov_gcta"
export COV_GCTA="$TMP/cov_gcta"

gen_path_array_id=$(eval echo $GEN_PATH)
gen_out_path_array_id=$(eval echo $GEN_OUT_PATH)

$GCTA \
	--pfile $gen_path_array_id \
	--grm-sparse ${OUT_GCTA}_sp \
	--fastGWA-mlm \
	--pheno $PHE \
	--qcovar $QCOV_GCTA \
	--covar $COV_GCTA \
	--thread-num $CPUS_OPENMP \
	--out $gen_out_path_array_id
