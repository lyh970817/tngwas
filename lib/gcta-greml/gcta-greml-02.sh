#!/bin/bash
set -e

export OUT_GCTA="$OUT/gcta_grm"
export PHE_GCTA="$TMP/phe_gcta"
export QCOV_GCTA="$TMP/qcov_gcta"
export COV_GCTA="$TMP/cov_gcta"

Rscript $UTILS/extract_columns.R $COV $CAT_VARS ${TMP}/cov_cat ${TMP}/cov_quant

sed '1d' $PHE >$PHE_GCTA
sed '1d' ${TMP}/cov_cat >$COV_GCTA
sed '1d' ${TMP}/cov_quant >$QCOV_GCTA

# Merge all the parts together
cat ${OUT_GCTA}.part_${NPARTS_GCTA}_*.grm.id >${OUT_GCTA}.grm.id
cat ${OUT_GCTA}.part_${NPARTS_GCTA}_*.grm.bin >${OUT_GCTA}.grm.bin
cat ${OUT_GCTA}.part_${NPARTS_GCTA}_*.grm.N.bin >${OUT_GCTA}.grm.N.bin

# Adjust for incomplete tagging of causal SNPs
$GCTA \
	--grm $OUT_GCTA \
	--grm-adj 0 \
	--make-grm \
	--out "$OUT_GCTA"_adj

# Remove related subjects using grm-cutoff 0.05. This will create a new GRM of "unrelated" individuals.
$GCTA \
	--grm "$OUT_GCTA"_adj \
	--grm-cutoff 0.05 \
	--make-grm \
	--out "$OUT_GCTA"_adj_unrel05

for ((i = 0; i < ${#PHES[@]}; i++)); do
	export p=${PHES[$i]}
	function run_gcta() {
		$GCTA \
			--reml \
			--grm $OUT_GCTA \
			--pheno $PHE_GCTA \
			--mpheno $((i + 1)) \
			--qcovar $QCOV_GCTA \
			--covar $COV_GCTA \
			--out $OUT/"$p"_gcta_h2 \
			--thread-num $CPUS_OPENMP
	}
	export -f run_gcta
	# srun -N1 --ntasks=1 --exact bash -exec 'run_gcta' &
	bash -exec 'run_gcta' &
done

# Wait until the `srun` tasks finish before terminating this subshell
wait
