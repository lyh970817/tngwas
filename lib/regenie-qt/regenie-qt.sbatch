jid1=$(sbatch --parsable -p "$partition" --output $log/%x_%a_%j.out --ntasks=$n_split --cpus-per-task=$cpus_openmp "$model"/regenie-qt-01.sh) 
jid_last=$(sbatch --parsable -p "$partition" --output $log/%x_%a_%j.out --dependency=afterok:$jid1 --cpus-per-task=$cpus_openmp --array=1-22 "$model"/regenie-qt-02.sh) 
jid_post_gwas=$(sbatch --parsable -p "$partition" --output $log/%x_%a_%j.out --dependency=afterok:$jid_last --ntasks=$n_phes --cpus-per-task=$cpus_openmp "$model"/regenie-qt-03.sh) 
jid_ldsc=$(sbatch --parsable -p "$partition" --output $log/%x_%a_%j.out --dependency=afterok:$jid_post_gwas --ntasks=$n_phes --cpus-per-task=$cpus_openmp "$model"/regenie-qt-04.sh)


