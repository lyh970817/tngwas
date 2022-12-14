#!/bin/bash

#SBATCH --mem=19000
#SBATCH --ntasks=1
#SBATCH --cpus_per_task=10
#SBATCH --mail-user=%u@kcl.ac.uk
#SBATCH --mail-type=ALL
#SBATCH --output $log/%x_%j.out
#SBATCH --array=1-23

regenie \
	--step 2 \
	--bed $gen_path_name \
	--covarFile $cov \
	--phenoFile $phe \
	--bsize 200 \
	--qt \
	--firth --approx \
	--force-qt \
	--pThresh 0.01 \
	--pred ${out_path_name}_pred.list \
	--out $out_path_name

. ./rbind_cleanup.sh
