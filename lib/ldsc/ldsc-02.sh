#!/bin/bash

#!/bin/bash
MUNGED_DIR=$OUT/ldsc_munged

traits=($(ls "$MUNGED_DIR"/*.sumstats.gz))

for ((i = 0; i < ${#traits[@]}; i++)); do
	for ((j = i + 1; j < ${#traits[@]}; j++)); do
		export trait1="${traits[i]}"
		export trait2="${traits[j]}"
		export out_file="$OUT/$(basename ${trait1%.sumstats.gz})_$(basename ${trait2%.sumstats.gz}).rg"

		# Skip if the correlation has already been calculated
		if [[ -f "$out_file" ]]; then
			echo "Skipping ${trait1%.sumstats.gz} vs ${trait2%.sumstats.gz}: already computed."
			continue
		fi

		function gencorr_ldsc() {
			# Run LDSC genetic correlation
			$LDSC/ldsc.py \
				--rg "$trait1,$trait2" \
				--ref-ld-chr "$LD_CHR"/ \
				--w-ld-chr "$LD_CHR"/ \
				--out "$out_file"
		}
		export -f gencorr_ldsc
		srun -N1 --ntasks=1 --exact bash -exec 'gencorr_ldsc' &
		# bash -exec 'gencorr_ldsc'
	done
done

wait
