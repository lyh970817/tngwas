# tngwas GWAS Pipeline

This is a simple and extensible GWAS pipeline writtien in `bash` to be used
with [Slurm Workload Manager](https://slurm.schedmd.com/overview.html).
Currenly the pipeline has model templates to run association analyses in `regenie`
and `plink2` as well as heritabiltiy estimates in `ldsc`. 

The `lib` folders contains the model templates which are structured as folders
containing a `*.sbatch` job submission script. 

## Usage

Clone the repository

```bash
git clone https://github.com/lyh970817/tngwas
```

Generate the default project directory structure in the repository folder

```bash
cd tngwas
./main.sh --init
```

An example config file which is required to run the pipeline will be generated.
If `ldsc` is to be used, make sure to specify the `ldsc`, `snp_list` and
`ld_chr` variables are specified.

Before actually running the pipeline, make sure to have your GWAS software in
the selected model template, `parallel` and `R` are in your `PATH` variable
(for example, with `module load`). The `qqman` and `data.table` R packages
should be installed.

To run the pipeline, specify the config file and the model template folder.

```bash
./main.sh --config config --model ./lib/regenie-bt
```

To clear the file content in `log` and `out` before running the model, add the
`--fresh` flag.

## Extending the pipeline

To extend the pipeline, it is as simple as creating a folder containing a set
of scripts to be submitted as `sbatch` jobs and a job submission script named
`FOLDERNAME.sbatch`. The scripts can utilize a number of pre-defined variables.
Check the exsiting model templates for examples.


