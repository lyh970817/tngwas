#!/bin/bash
set -e

export maf_col='$6'
export logp_col='$13'

for p in $PHES; do
	export p

	# Add header and change LOG10P to P (change value later)
	head -1 $OUT/$(echo $GEN_BASE_NAMES | cut -d' ' -f1)_"$p"$suffix |
		sed 's/LOG10P/P/' \
			>$OUT/"$sumstat_all"_"$p"$suffix

	function merge_sumstats() {
		sed '1d' $OUT/"$1"_"$p"$suffix |
			awk -v maf=$MAF "$maf_col >= maf{$logp_col=10^(-$logp_col);print}" &&
			find $OUT -name "$1"_"$p"$suffix -type f -exec rm {} \;
	}
	export -f merge_sumstats

	# Does parallel really speed it up? Guess file reading speed is important
	# perhaps fread
	# srun -N1 --ntasks=1 --exact
	parallel merge_sumstats {} ::: $GEN_BASE_NAMES \
		>>$OUT/"$sumstat_all"_"$p"$suffix &

	find $OUT -name *.loco -type f -exec rm {} \;
	find $OUT -name *.list -type f -exec rm {} \;
	find $OUT -name *.master -type f -exec rm {} \;

done

wait
