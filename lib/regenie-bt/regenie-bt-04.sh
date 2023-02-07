#!/bin/bash
set -e

export suffix=.regenie

export sumstat_all=$(echo $gen_base_name_jobtem | sed 's/${SLURM_ARRAY_TASK_ID}/ALL/')

for p in $phes; do
    export p
    function run_ldsc() {
	awk 'NR==1{print "SNP A1 A2 freq INFO p beta SE N"} \
     NR > 1{print $3, $5, $4, $6, $7, $13, $10, $11, $8}' \
		$out/"$sumstat_all"_"$p"$suffix >$tmp/"$p"_tomunge.ldsc

	$ldsc/munge_sumstats.py \
		--sumstats $tmp/"$p"_tomunge.ldsc \
		--info-min 0.3 --chunksize 50000 \
		--merge-alleles $snp_list \
		--out $tmp/"$p"_munged.ldsc

	$ldsc/ldsc.py \
		--h2 $tmp/"$p"_munged.ldsc.sumstats.gz \
		--ref-ld-chr $ld_chr \
		--w-ld-chr $ld_chr \
		--out $out/$p$_h2.ldsc
    }
    export -f run_ldsc
	srun -N1 --ntasks=1 --exact bash -exec 'run_ldsc' &

done

wait

