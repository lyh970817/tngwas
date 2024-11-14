# `fastgwa`

* Download `gcta` and set its paths in `config`.
* Load `R` and `parallel` in `slurm`.
* Prepare imputed genetic files in `pgen` format, split by chromosomes, and place them in the `GEN` directory as specified in `config`.
* Prepare phenotype and covariate files in space-delimited PLINK format and set paths to them in `config`.
* Specify categorical covariates with `CAT_VARS` in `config`.
