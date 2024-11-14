#!/bin/bash

export suffix=.fastGWA
export sumstat_all=$(echo $GEN_BASE_NAME_JOBTEM | sed 's/${SLURM_ARRAY_TASK_ID}/ALL/')

cat "$PIPE"/README.md

jid_gcta_mpfile=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	"$PIPE"/gcta-fastgwa-01.sh)

jid_gcta_grm=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_gcta_mpfile \
	--cpus-per-task=$CPUS_OPENMP --array=1-"$NPARTS_GCTA" "$PIPE"/gcta-fastgwa-02.sh)

jid_gcta_grm_sp=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_gcta_grm \
	"$PIPE"/gcta-fastgwa-03.sh)

jid_gcta_fastgwa=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_gcta_grm_sp \
	--array=1-$N_GEN --cpus-per-task=$CPUS_OPENMP "$PIPE"/gcta-fastgwa-04.sh)

jid_gcta_fastgwa_merge=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_gcta_fastgwa \
	--cpus-per-task=$CPUS_OPENMP "$PIPE"/gcta-fastgwa-05.sh)
