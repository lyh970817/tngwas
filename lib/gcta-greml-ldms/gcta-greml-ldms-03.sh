#!/bin/bash
set -e

export OUT_GCTA="$OUT/gcta_grm"

for i in {1..4}; do
	$GCTA \
		--mbfile $TMP/gcta_grm_bfiles.list \
		--make-grm-part $NPARTS_GCTA $SLURM_ARRAY_TASK_ID \
		--maf 0.01 \
		--extract ${OUT_GCTA}_snp_group${i}.txt \
		--out ${OUT_GCTA}_${i} \
		--thread-num $CPUS_OPENMP
done
