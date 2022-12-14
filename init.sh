#!/bin/bash

echo "\
# Specify path to genotype file folder
gen="$(pwd)/$1"/gen
# Specify path to phenotype file 
phe="$(pwd)/$1"/phe/phe
# Specify path to covariates file
cov="$(pwd)/$1"/phe/cov
# Specify path to gwas output folder
out="$(pwd)/$1"/out

# Specify path to association template folder
assoc="$(pwd)/$1"/assoc/regenie
# Specify path to utility scripts
preprocess="$(pwd)/$1"/preprocess/regenie_preprocess
# Specify path to log folder
log="$(pwd)/$1"/log" > "$(pwd)/$1"/config


