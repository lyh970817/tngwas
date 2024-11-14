#!/bin/bash
set -e

export suffix=.glm.linear

export sumstat_all=$(echo $GEN_BASE_NAME_JOBTEM | sed 's/${SLURM_ARRAY_TASK_ID}/ALL/')

for p in $phes; do
	export p
	function run_ldsc() {
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
	srun -N1 --ntasks=1 --exact bash -exec 'run_ldsc' &

done

wait
