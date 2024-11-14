#!/bin/bash
set -e

for p in $PHES; do
	# srun -N1 --ntasks=1 --exact \
	Rscript --vanilla $UTILS/manhattan_plot.R \
		$OUT/"$sumstat_all"_"$p"$suffix "CHROM" "GENPOS" "ID" "P" &

	# srun -N1 --ntasks=1 --exact \
	Rscript --vanilla $UTILS/qq_plot.R \
		$OUT/"$sumstat_all"_"$p"$suffix "P" &
done

wait
