#!/bin/bash

#SBATCH --ntasks=4
#SBATCH --cpus-per-task=10
#SBATCH --mail-user=%u@kcl.ac.uk
#SBATCH --mail-type=ALL
#SBATCH --array=1-23

# Create paths based on array id
gen_base_name_array_id=$(eval echo $gen_base_name)
echo $gen_base_name_array_id
gen_path_name="$gen/$gen_base_name_array_id"
out_path_name="$out/$gen_base_name_array_id"

# Create tmp directory
tmp_path_name="$out/.tmp/$gen_base_name_array_id"
mkdir -p $tmp_path_name

# Set number of threads to use
threads=$((SLURM_CPUS_PER_TASK - 2))

# Set number of jobs
n_split=$SLURM_NTASKS

base_command="regenie \
 --step 1 \
 --bed $gen_path_name \
 --covarFile $cov \
 --phenoFile $phe \
 --bsize 10 \
 --qt \
 --force-qt \
 --lowmem \
 --lowmem-prefix $tmp_path_name \
 --threads $threads"

srun -N1 --ntasks=1 --exact $base_command \
	--out $out_path_name \
	--split-l0 ${out_path_name}_split,$n_split

for job in $(seq 1 $n_split); do
	  srun -N1 --ntasks=1 --exact \
          $base_command --out $out_path_name --run-l0 ${out_path_name}_split.master,$job &
done

srun -N1 --ntasks=1 --exact \
    $base_command \
	--out $out_path_name \
	--run-l1 ${out_path_name}_split.master

wait
