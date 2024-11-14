#!/bin/bash

cat "$PIPE"/README.md


jid_ldak_calc=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--array=1-$N_GEN --cpus-per-task=$CPUS_OPENMP "$PIPE"/ldak-01.sh)

jid_ldak_add=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_ldak_calc \
	--cpus-per-task=$CPUS_OPENMP "$PIPE"/ldak-02.sh)

jid_ldak_reml=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_ldak_add \
	--cpus-per-task=$CPUS_OPENMP "$PIPE"/ldak-03.sh)
