#!/bin/bash
# set -e

gen_path_array_id=$(eval echo $gen_path)
gen_out_path_array_id=$(eval echo $gen_out_path)

plink2 \
--pfile $gen_path_array_id \
--exclude-if-info "INFO >= $info" \
--glm linear cols=+a1freq \
--pheno $phe  \
--covar $cov \
--out $gen_out_path_array_id


