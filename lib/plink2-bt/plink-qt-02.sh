#!/bin/bash
set -e

export suffix=.glm.firth
export maf_col='$7'

export sumstat_all=$(echo $gen_base_name_jobtem | sed 's/${SLURM_ARRAY_TASK_ID}/ALL/')

for p in $phes; do
      export p
      
      # Add header and change LOG10P to P (change value later)
      head -1 $out/$(echo $gen_base_names|cut -d' ' -f1)_"$p"$suffix|

	function merge_sumstats() {
		sed '1d' $out/"$1"_"$p"$suffix |
			awk -v maf=$maf "$maf_col >= maf" &&
            find $out -name "$1"_"$p"$suffix -type f -exec rm {} \;
	}
    export -f merge_sumstats
     
	# Does parallel really speed it up? Guess file reading speed is important
	# perhaps fread
	srun -N1 --ntasks=1 --exact parallel merge_sumstats {} ::: $gen_base_names \
        >>$out/"$sumstat_all"_"$p"$suffix &

    find $out -name *.loco -type f -exec rm {} \;
    find $out -name *.list -type f -exec rm {} \;
    find $out -name *.master -type f -exec rm {} \;
    find $out -name *.log -type f -exec mv {} $log \;

done

wait
