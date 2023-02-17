#!/bin/bash
# set -e

gen_path_array_id=$(eval echo $GEN_PATH)
gen_out_path_array_id=$(eval echo $GEN_OUT_PATH)

# Set number of threads to use
threads=$((SLURM_CPUS_PER_TASK))

regenie \
	--step 2 \
	--pgen $gen_path_array_id \
	--covarFile $COV \
	--phenoFile $PHE \
	--catCovarList "$CAT_VARS" \
	--bsize 400 \
	--qt \
	--approx \
	--minINFO $INFO \
	--pred ${GTP_OUT_PATH}_pred.list \
	--out $gen_out_path_array_id \
	--threads $CPUS_OPENMP
