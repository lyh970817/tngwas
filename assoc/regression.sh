#!/bin/bash -l
#SBATCH --output=/scratch/groups/ukbiobank/usr/lyh970817/logs/%j.out
#SBATCH --time=0-24:00
#SBATCH --mem=10240

plink \
--logistic hide-covar \
--all-pheno \
--bfile $rootfile \
--pheno $pheno  \
--covar $covar \
--covar-number 1-10 \
--ci 0.95 \
--out $outfile

# Munging
# Add A2 col
sh "$utils"/add_cols.sh $rootfile $outfile
# Change header NMISS (first occurence in file) to N so that ldsc recognises it
# This is slow (how to change?)
sed -i '0,/NMISS/{s/NMISS/N/}' $outfile*assoc*
