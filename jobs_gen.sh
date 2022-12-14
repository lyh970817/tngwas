#!/bin/bash

set -a
source ./config
set +a

# Get gen file names without suffix
gen_base_names=($(basename -a $gen/* | cut -f1 -d. | sort -u))

# Each gen_base_name shoud have exactly one occurence of the pattern chr[0-9][0-9]*
for gn in $gen_base_names; do
	if [ $(echo $gn | grep -o chr[0-9][0-9]* | wc -l) != 1 ]; then
		exit 1
	fi
done

# Format gen file name for job array submission
gen_base_name_a=($(
	for n in ${gen_base_names[@]}; do
		echo $n
	done |
		# for loop to print on different lines to sort
		sed 's/chr[0-9][0-9]*/chr${SLURM_ARRAY_TASK_ID}/' | sort -u
))

# Number of files should be 23
if [ ${#gen_base_names[@]} != 23 ]; then
	echo "Only $#gen_base_names chromosome files found."
	exit 1
fi

# File names should be the same except for chromosome number
if [ ${#gen_base_name_a[@]} != 1 ]; then
	echo "File names should be the same except for chromosome number."
	exit 1
fi

# Run preprocess scripts
preprocess_scripts=($(ls $preprocess/* | grep '/[0-9][0-9]*'))

for s in ${preprocess_scripts[@]}; do
    . $s
done

# Submit assoc pipeline scripts
pipe_scripts=($(ls $assoc/* | grep '/[0-9][0-9]*'))

# Export first element of the array (array itself can't be exported)
# to use in assocation script
export gen_base_name=$gen_base_name_a

jid=$(sbatch -p cpu --output $log/%x_%j_%a.out ${pipe_scripts[0]})
# if [ ${#pipe_scripts[@]} -gt 1 ]; then
# 	for s in ${pipe_scripts[@]}; do
# 		jid=$(sbatch -p cpu --output $log/%x_%j_$a.out --dependency=afterok:$jid $s)
# 	done
# fi

