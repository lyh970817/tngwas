#!/bin/bash

cat "$PIPE"/README.md

jid_gcta_mbfile=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	"$PIPE"/gcta-greml-ldms-01.sh)

jid_gcta_greml_ldms_ld=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_gcta_mbfile \
	--array=1-$N_GEN --cpus-per-task=$CPUS_OPENMP "$PIPE"/gcta-greml-ldms-02.sh)

jid_gcta_greml_ldms_grm=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_gcta_greml_ldms_ld \
	--cpus-per-task=$CPUS_OPENMP --array=1-"$NPARTS_GCTA" "$PIPE"/gcta-greml-ldms-03.sh)

jid_gcta_greml_ldms_h2=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out \
	--dependency=afterok:$jid_gcta_greml_ldms_grm \
	--ntasks=$N_PHES --cpus-per-task=$CPUS_OPENMP "$PIPE"/gcta-greml-ldms-04.sh)
