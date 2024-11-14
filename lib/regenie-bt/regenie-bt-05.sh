#!/bin/bash
set -e

export suffix=.regenie

export sumstat_all=$(echo $GEN_BASE_NAME_JOBTEM | sed 's/${SLURM_ARRAY_TASK_ID}/ALL/')

for p in $PHES; do
	export p
	function run_ldsc() {
		awk 'NR==1{print "SNP A1 A2 freq INFO p beta SE N"} \
     NR > 1{print $3, $5, $4, $6, $7, $13, $10, $11, $8}' \
			$OUT/"$sumstat_all"_"$p"$suffix >$TMP/"$p"_tomunge.ldsc

		$LDSC/munge_sumstats.py \
			--sumstats $TMP/"$p"_tomunge.ldsc \
			--info-min 0.3 --chunksize 50000 \
			--merge-alleles $SNP_LIST \
			--out $TMP/"$p"_munged.ldsc

		$LDSC/ldsc.py \
			--h2 $TMP/"$p"_munged.ldsc.sumstats.gz \
			--ref-ld-chr $LD_CHR/ \
			--w-ld-chr $LD_CHR/ \
			--out $OUT/$p$_h2.ldsc
	}
	export -f run_ldsc
	# srun -N1 --ntasks=1 --exact bash -exec 'run_ldsc' &
	run_ldsc
done

wait
