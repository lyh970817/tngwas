#!/bin/bash

# https://rgcgithub.github.io/regenie/install/#memory-usage
# Not very accurate?

# Speciy R, B and n_split in this script and uncomment a line containing `mem_byte`
# depending on whether --lowmem used 

# How to consider covariates?
# export gen=/home/lyh970817/Disk/Projects/Research/Pipelines/TNG-GWAS-Pipeline/gen
# export phe=/home/lyh970817/Disk/Projects/Research/Pipelines/TNG-GWAS-Pipeline/phe/phe

# Number of ridge parameters from -l0
R=5

# Blocksize 
B=1000

# Number of split if --split-l0 used, 1 if not used
n_split=1

# Number of phenotypes
P=$(expr `head -n 1 $phe | awk '{print NF}'` - 2)

# Number of SNPs (support for different formats)
M=`wc -l $gen/*.bim|
    # Remove the last "total line" output from wc
    head -n -1|
    awk '{print $1}'|
    # Get the largest
     sort -n|tail -1`

# Number of samples
N=`wc -l $gen/*.fam|
    # Remove the last "total line" output from wc
    head -n -1|
    awk '{print $1}'|
    # Get the largest
     sort -n|tail -1`


# Calculate memory usage in byte (8 byte per double)

# --lowmem used
mem_byte=$((N *M / B * R / n_split * 8))
#
# --lowmem not used
# mem_byte=$((N *M / B * R * P / n_split * 8))

# Convert to megabyte with 1024M overhead?
mem="$((mem_byte / 1024**2 + 1024))M"
#
# Set sbatch parameter
alias sbatch="sbatch --mem $mem"


