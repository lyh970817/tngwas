jid_last=$(sbatch_gwas --dependency=afterok:$jid1 --cpus-per-task=$cpus_openmp --array=1-22 "$model"/plink2-bt-01.sh)
jid_post_gwas=$(sbatch --parsable -p "$partition" --output $log/%x_%a_%j.out --dependency=afterok:$jid_last --ntasks=$n_phes --cpus-per-task=$cpus_openmp "$model"/plink2-bt-02.sh) 
jid_ldsc=$(sbatch --parsable -p "$partition" --output $log/%x_%a_%j.out --dependency=afterok:$jid_post_gwas --ntasks=$n_phes --cpus-per-task=$cpus_openmp "$model"/plink2-bt-03.sh)


