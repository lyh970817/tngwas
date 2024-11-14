#!/bin/bash

base_command="$REGENIE \
 --step 1 \
 --bed $GTP_PATH \
 --phenoFile $PHE \
 --covarFile $COV \
 --catCovarList "$CAT_VARS" \
 --bsize 1000 \
 --qt \
 --lowmem \
 --lowmem-prefix $TMP \
 --threads $CPUS_OPENMP"

srun -N1 --ntasks=1 --exact \
	--output "$LOG"/"$GTP_BASE_NAME"_split.out \
	$base_command \
	--force-step1 \
	--out $GTP_OUT_PATH \
	--split-l0 ${GTP_OUT_PATH}_split,$N_SPLIT

wait

for job in $(seq 1 $N_SPLIT); do
	srun -N1 --ntasks=1 --exact \
		--output "$LOG"/"$GTP_BASE_NAME"_l0_"$job".out \
		$base_command --out $GTP_OUT_PATH --run-l0 ${GTP_OUT_PATH}_split.master,$job &
done

wait

srun -N1 --ntasks=1 --exact --output "$LOG"/"$GTP_BASE_NAME"_l1.log \
	$base_command \
	--out $GTP_OUT_PATH \
	--run-l1 ${GTP_OUT_PATH}_split.master
