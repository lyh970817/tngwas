#!/bin/bash
set -e

# Add header
head -1 $OUT/$(echo $GEN_BASE_NAMES | cut -d' ' -f1)$suffix \
	>$OUT/"$sumstat_all"_"$p"$suffix

function merge_sumstats() {
	sed '1d' $OUT/"$1"$suffix &&
		find $OUT -name "$1"$suffix -type f -exec rm {} \;
}
export -f merge_sumstats

# Does parallel really speed it up? Guess file reading speed is important
# perhaps fread
# srun -N1 --ntasks=1 --exact
parallel merge_sumstats {} ::: $GEN_BASE_NAMES \
	>>$OUT/"$sumstat_all"$suffix &

wait
