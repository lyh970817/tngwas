#!/bin/bash

# Create tmp directory
tmp_path="$out/.tmp/$gtp_base_name"
mkdir -p $tmp_path

base_command="regenie \
 --step 1 \
 --bed $gtp_path \
 --covarFile $cov \
 --phenoFile $phe \
 --catCovarList $cat_vars \
 --bsize 1000 \
 --bt \
 --lowmem \
 --lowmem-prefix $tmp_path \
 --threads $cpus_openmp"

srun -N1 --ntasks=1 --exact \
     --output "$log"/"$gtp_base_name"_split.out \
     $base_command \
     --force-step1 \
     --out $gtp_out_path \
     --split-l0 ${gtp_out_path}_split,$n_split

for job in $(seq 1 $n_split); do
	  srun -N1 --ntasks=1 --exact \
           --output "$log"/"$gtp_base_name"_l0_"$job".out \
           $base_command --out $gtp_out_path --run-l0 ${gtp_out_path}_split.master,$job &
done

wait

srun -N1 --ntasks=1 --exact --output "$log"/"$gtp_base_name"_l1.log \
     $base_command \
	 --out $gtp_out_path \
	 --run-l1 ${gtp_out_path}_split.master
