#!/bin/bash
# set -e

gen_path_array_id=$(eval echo $GEN_PATH)
gen_out_path_array_id=$(eval echo $GEN_OUT_PATH)

plink2 \
	--pfile $gen_path_array_id \
	--exclude-if-info "INFO >= $INFO" \
	--glm linear cols=+a1freq \
	--pheno $PHE \
	--covar $COV \
	--out $GEN_OUT_PATH_ARRAY_ID
