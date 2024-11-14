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

for i in {1..4}; do
	# Merge all the parts together
	cat ${OUT_GCTA}_${i}.part_${NPARTS_GCTA}_*.grm.id >${OUT_GCTA}_${i}.grm.id
	cat ${OUT_GCTA}_${i}.part_${NPARTS_GCTA}_*.grm.bin >${OUT_GCTA}_${i}.grm.bin
	cat ${OUT_GCTA}_${i}.part_${NPARTS_GCTA}_*.grm.N.bin >${OUT_GCTA}_${i}.grm.N.bin

	echo "${OUT_GCTA}_${i}" >>${OUT_GCTA}_multi_GRMs.txt
done

for ((i = 0; i < ${#PHES[@]}; i++)); do
	export p=${PHES[$i]}
	function run_gcta() {
		$GCTA \
			--reml \
			--mgrm ${OUT_GCTA}_multi_GRMs.txt \
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

wait
