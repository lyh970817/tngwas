#!/bin/bash

jid_last=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--cpus-per-task=$CPUS_OPENMP --array=1-22 "$PIPE"/plink2-bt-01.sh)

jid_post_gwas=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_last \
	--ntasks=$N_PHES --cpus-per-task=$CPUS_OPENMP "$PIPE"/plink2-bt-02.sh)

jid_ldsc=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_post_gwas \
	--ntasks=$N_PHES --cpus-per-task=$CPUS_OPENMP "$PIPE"/plink2-bt-03.sh)
