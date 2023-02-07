jid1=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out --ntasks=$N_SPLIT --cpus-per-task=$CPUS_OPENMP "$MODEL"/regenie-qt-01.sh) 
jid_last=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out --dependency=afterok:$jid1 --cpus-per-task=$CPUS_OPENMP --array=1-22 "$MODEL"/regenie-qt-02.sh) 
jid_post_gwas=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out --dependency=afterok:$jid_last --ntasks=$N_PHES --cpus-per-task=$CPUS_OPENMP "$MODEL"/regenie-qt-03.sh) 
jid_ldsc=$(sbatch --parsable -p "$PARTITION" --output $LOG/%x_%a_%j.out --dependency=afterok:$jid_post_gwas --ntasks=$N_PHES --cpus-per-task=$CPUS_OPENMP "$MODEL"/regenie-qt-04.sh)


