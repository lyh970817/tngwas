#!/bin/bash

cat "$PIPE"/README.md

jid_gcta_grm=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--cpus-per-task=$CPUS_OPENMP --array=1-"$NPARTS_GCTA" "$PIPE"/gcta-greml-01.sh)

jid_gcta_h2=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_gcta_grm \
	--ntasks=$N_PHES --cpus-per-task=$CPUS_OPENMP "$PIPE"/gcta-greml-02.sh)
