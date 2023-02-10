# tngwas

This is a simple and extensible GWAS pipeline writtien in `bash` to be used
with [Slurm Workload Manager](https://slurm.schedmd.com/overview.html).
Currenly the pipeline has pipeline templates to run association analyses
(including manhattan and QQ plots) in `regenie` and `plink2` as well as
heritabiltiy estimation in `ldsc`. 

The `lib/` directory contains default pipeline templates which are structured as
directoris containing a `*.sbatch` job submission script. The pipeline templates
can also use scripts in `utils/` (which is design to keep scripts usable by
multiple pipeline templates and can be set by the `UTILS` variable in the config
file).

## Usage

Clone the repository

```bash
git clone https://github.com/lyh970817/tngwas
```

Generate the default project directory structure in the repository direcotry

```bash
cd tngwas
./main.sh --init
```

An example config file which is required to run the pipeline will be generated.
If `ldsc` is to be used, make sure to specify the `ldsc`, `snp_list` and
`ld_chr` variables.

Before actually running the pipeline, make sure to have the GWAS software in
the selected pipeline template, `parallel` and `R` in your `PATH` variable (for
example, using `module load`). The `qqman` and `data.table` R packages should
also be installed.

To run the pipeline, specify the config file and a pipeline template directory.

```bash
./main.sh --config config --pipe ./lib/regenie-bt
```

To clear the file content in `LOG` and `OUT` before running the pipeline, add the
`--fresh` flag.

## Extending the pipeline

To extend the pipeline, it is as simple as creating a directory containing a
set of scripts to be submitted as `sbatch` jobs and a job submission script
named `DIRECTORYNAME.sbatch`. The scripts can utilize a number of pre-defined
variables and use sharable scripts kept in the directory set by `UTILS` in the
config file. Check the exsiting pipeline templates for examples. 

