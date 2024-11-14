#!/bin/bash

cat "$PIPE"/README.md

export suffix=.regenie
export sumstat_all=$(echo $GEN_BASE_NAME_JOBTEM | sed 's/${SLURM_ARRAY_TASK_ID}/ALL/')

jid1=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--ntasks=$N_SPLIT --cpus-per-task=$CPUS_OPENMP "$PIPE"/regenie-qt-01.sh)

jid_last=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid1 \
	--cpus-per-task=$CPUS_OPENMP --array=1-$N_GEN "$PIPE"/regenie-qt-02.sh)

jid_post_gwas=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_last \
	--ntasks=$N_PHES --cpus-per-task=$CPUS_OPENMP "$PIPE"/regenie-qt-03.sh)

jid_plot=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_post_gwas \
	--ntasks=$(($N_PHES * 2)) --cpus-per-task=2 --mem-per-cpu=$MEM_PER_CPU "$PIPE"/regenie-qt-04.sh)

jid_ldsc=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_post_gwas \
	--ntasks=$N_PHES --cpus-per-task=$CPUS_OPENMP "$PIPE"/regenie-qt-05.sh)
