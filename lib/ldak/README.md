# `ldak` for Heritability Estimation

* Download `ldak` and set its path in `config`.
* Load `R` in `slurm`.
* Prepare imputed genetic files in `bed` format, split by chromosomes, and place them in the `GEN` directory as specified in `config`.
* Prepare phenotype and covariate files in space-delimited PLINK format and set paths to them in `config`.
* Specify categorical covariates with `CAT_VARS` in `config`.

**TODO:** Should quality control be implemented?
