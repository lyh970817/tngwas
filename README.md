# tngwas

This is a simple and extensible GWAS pipeline written in `bash` to be used with
the [Slurm Workload Manager](https://slurm.schedmd.com/overview.html).
Currently, the pipeline includes templates for running association analyses in
`regenie` and `plink2`, as well as heritability estimation in `ldsc`, `gcta`,
and `ldak`. There is also a template for running genetic correlation analyses
in `ldsc`.

The `lib/` directory contains default pipeline templates structured as
directories containing `*.sbatch` job submission scripts. The pipeline
templates can also use scripts in `utils/` (designed for use across multiple
pipelines).

## Usage

Clone the repository:

```bash
git clone https://github.com/lyh970817/tngwas
```

Generate the default project directory structure in the current directory:

```bash
cd tngwas
./main.sh --init
```

An example config file required to run the pipeline will be generated. 

Before running a pipeline, read the `README.md` file under the pipeline
directory in `lib/`. To run a pipeline, specify the config file and a pipeline
directory:

```bash
./main.sh --config config --pipe ./lib/regenie-bt
```

To clear the file content in `LOG` and `OUT` before running the pipeline, use the `--fresh` flag.

## Tips for Using Parallelization on `SLURM`

There are two types of parallelization enabled by `SLURM`.

1. **Multithreading**: In this type of parallelization, multiple CPUs on a
   single node can be used, sharing memory. This is typically used for numeric
   calculations within a program, such as matrix algebra. For instance, one
   could request `regenie` to use 15 CPUs for association analyses on a
   genotype file. This can be set in `config` with the `CPUS_OPENMP` variable.
   Note that a program may not use all CPUs for every operation, as only some
   operations can be parallelized.

2. **Distributed Parallelization**: This type allows the use of multiple nodes
   concurrently, each running a different command, while each node can use
   multithreading. This is enabled by the `--array` and `--ntasks` features in
   `SLURM`. In practice, different parts of a node can act as separate nodes,
   each running its own job. For instance, one can submit multiple jobs to use
   `regenie` to run association analyses for each chromosome concurrently using
   `--array`. Alternatively, one could split the calculation of genetic
   relatedness matrices in `GCTA` into different parts, allowing different
   nodes (or parts of a node) to calculate them simultaneously. This needs to
   be configured for each program, with relevant options in `config` (e.g.,
   `NPARTS_GCTA`). Since each calculation is conducted on different nodes with
   unshared memory, the results are stored on the hard disk and need to be
   combined afterward, adding some overhead to the computation time.

A `SLURM` user on KCL CREATE can only use a fixed number of CPUs (255) at one time.
If `CPUS_OPENMP` is set to 15 and the calculation is split into 10 parts, 150
CPUs will be requested. Adjust these settings if resources are limited.
Alternatively, specify the fallback partition `interruptible_cpu`, though jobs
submitted here may be terminated arbitrarily. See
https://docs.er.kcl.ac.uk/CREATE/scheduler_policy/#interruptible-partitions.

Splitting the calculation is generally less resource-demanding (it is easier to
request 30 CPUs across 5 nodes than 30 CPUs on a single node). While splitting
adds overhead to combine results afterward, it is not necessarily slower than
multithreading since a program may not fully utilize all CPUs at all times.

## Extending the Pipeline

To extend the pipeline, simply create a directory containing a set of scripts
to be submitted as `sbatch` jobs and a job submission script named
`DIRECTORYNAME.sbatch`. The scripts can use several predefined variables and
sharable scripts in the directory set by `UTILS` in the config file. Check the
existing pipeline templates for examples. Detailed instructions and
explanations of these variables will be added.

## Known Issues

`srun` is currently non-functional if jobs are submitted from non-login nodes,
which disables some parallelization options.
