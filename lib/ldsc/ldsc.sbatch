#!/bin/bash

cat "$PIPE"/README.md

jid_ldsc_munge=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--ntasks=$N_SUMSTATS --cpus-per-task=$CPUS_OPENMP "$PIPE"/ldsc-01.sh)

jid_ldsc_corr=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_ldsc_munge \
	--ntasks=$((N_SUMSTATS * (N_SUMSTATS - 1) / 2)) \
	--cpus-per-task=$CPUS_OPENMP "$PIPE"/ldsc-02.sh)
