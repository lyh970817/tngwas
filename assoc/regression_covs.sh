#!/bin/bash -l
#SBATCH --output=/scratch/groups/ukbiobank/usr/lyh970817/logs/%j.out
#SBATCH --time=0-24:00
#SBATCH --mem=10240

module load apps/plink

root=/scratch/groups/ukbiobank/usr/lyh970817/geno_dat/chr
pheno=/scratch/groups/ukbiobank/usr/lyh970817/phey/phe
covar=/scratch/groups/ukbiobank/usr/lyh970817/phey/covs

plink \
--logistic sex hide-covar \
--all-pheno \
--bfile $root \
--pheno $pheno  \
--covar $covar \
--covar-number 1-11 \
--ci 0.95 \
--out /scratch/groups/ukbiobank/usr/lyh970817/results_covs/chr
