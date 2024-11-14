# `plink` for Quantitative Traits

* Download `plink2` and set its path in `config`.
* Load `R`, `python`, `parallel`, and `anaconda` in `slurm`.
* Install the `qqman` and `data.table` packages in `R`.
* Download `ldsc`, the corresponding SNP list, and LD score file, and set paths to these in `config`.
* Follow the README in the `ldsc` folder to run `conda env create --file environment.yml`.
* Run `source activate ldsc3`.
* Prepare phenotype and covariate files in space-delimited PLINK format and set paths to them in `config`.
