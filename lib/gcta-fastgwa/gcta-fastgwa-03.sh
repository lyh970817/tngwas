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

$GCTA --grm $OUT_GCTA --make-bK-sparse 0.05 --out ${OUT_GCTA}_sp
