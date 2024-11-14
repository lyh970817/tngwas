# `regenie` for Binary Traits

* Download `regenie` and set its path in `config`.
* Load `R`, `python`, `parallel`, and `anaconda` in `slurm`.
* Install the `qqman` and `data.table` packages in `R`.
* Download `ldsc`, the corresponding SNP list, and LD score file, and set paths to these in `config`.
* Follow the README in the `ldsc` folder to run `conda env create --file environment.yml`.
* Run `source activate ldsc3`.
* Prepare imputed genetic files in `pgen` format, split by chromosomes, and place them in the `GEN` directory as specified in `config`.
* Prepare genotype files in `bed` format and place them in the `GTP` directory as specified in `config`.
* Prepare phenotype and covariate files in space-delimited PLINK format and set paths to them in `config`.
* Specify categorical covariates with `CAT_VARS` in `config`.
