#!/bin/bash
# set -e

gen_path_array_id=$(eval echo $gen_path)
gen_out_path_array_id=$(eval echo $gen_out_path)

# Set number of threads to use
threads=$((SLURM_CPUS_PER_TASK))

regenie \
	--step 2 \
	--pgen $gen_path_array_id \
	--covarFile $cov \
	--phenoFile $phe \
    --catCovarList "$cat_vars" \
	--bsize 400 \
	--qt \
    --approx \
    --minINFO $info \
	--pred ${gtp_out_path}_pred.list \
	--out $gen_out_path_array_id \
    --threads $cpus_openmp
