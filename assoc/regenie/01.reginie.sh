#!/bin/bash -l

#SBATCH --time=4:00:00
#SBATCH --ntasks=1
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

regenie \
	--step 1 \
	--force-step1 \
	--bed $gen_path_name \
	--covarFile $cov \
	--phenoFile $phe \
	--bsize 1000 \
	--qt \
	--force-qt \
	--lowmem \
	--lowmem-prefix $tmp_path_name/ \
	--out $out_path_name \
	--threads $threads \
	--gz

regenie \
	--step 2 \
	--bed $gen_path_name \
	--covarFile $cov \
	--phenoFile $phe \
	--bsize 200 \
	--qt \
	--firth --approx \
	--force-qt \
	--threads $threads \
	--pThresh 0.01 \
	--pred ${out_path_name}_pred.list \
	--out $out_path_name

# Get output file names (separated by phenotype) 
out_files=($(awk -v out=$out_path_name '{print out"_"$1".regenie" }' ${out_path_name}_pred.list))

# Generate sumstats for all chromosomes file names (separated by phenotype)
sumstat_path_name=$(echo $out/$gen_base_name | sed 's/${SLURM_ARRAY_TASK_ID}/ALL/')
sumstats_files=$(awk -v out=$sumstat_path_name '{print out"_"$1".regenie" }' ${out_path_name}_pred.list)

# Create sumstat files for all chromosomes (if existant, no change)
for f in $sumstats_files;do
    touch $f
done

# Append to sumstat files
for (( i = 0; i < ${#sumstats_files[@]}; i++ )); do
   cat ${out_files[i]} >> ${sumstats_files[i]}
done

# Remove files from step 1
rm ${out_path_name}_*.loco.*
rm ${out_path_name}_pred.list


