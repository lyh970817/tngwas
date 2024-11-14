#!/bin/bash

MUNGED_DIR=$OUT/ldsc_munged

mkdir -p "$MUNGED_DIR"

for file in "$SUMSTATS"/*; do
	# Export variables so that they are visible within function
	export file
	export trait=$(basename "$file")
	export munged_file="$MUNGED_DIR/${trait}.sumstats.gz"

	# Skip if munged file already exists
	if [[ -f "$munged_file" ]]; then
		echo "Skipping munging for $trait: already munged."
		continue
	fi

	function munge_ldsc() {
		$LDSC/munge_sumstats.py \
			--sumstats "$file" \
			--info-min 0.3 --chunksize 50000 \
			--merge-alleles $SNP_LIST \
			--out $munged_file
	}

	export -f munge_ldsc
	srun -N1 --ntasks=1 --exact bash -exec 'munge_ldsc' &
	# bash -exec 'munge_ldsc'
done

wait
