#!/bin/bash
set -e

export OUT_GCTA="$OUT/gcta_grm"

$GCTA \
	--bfile $GTP \
	--make-grm-part $NPARTS_GCTA $SLURM_ARRAY_TASK_ID \
	--maf 0.01 \
	--out $OUT_GCTA \
	--thread-num $CPUS_OPENMP
