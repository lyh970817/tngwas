#!/bin/bash
set -a

function help() {
	echo "help"
}

function init() {
	if [ -z $1 ]; then
		path_prefix="$PWD"
		config_path="$PWD/config"
	else
		path_prefix="$PWD/$1"
		config_path="$PWD/$1/config"
	fi

	cat <<EOF >$config_path
# Specify path to imputed genetic data file folder
gen="$path_prefix/gen"
# Specify path to genotype data file folder
gtp="$path_prefix/gtp"
# Specify path to phenotype file 
phe="$path_prefix/phe/phe"
# Specify path to covariates file
cov="$path_prefix/phe/cov"
# Specify path to gwas output folder
out="$path_prefix/out"
# Specify path to log folder
log="$path_prefix/log"
# Specify path to tmp folder
tmp="$path_prefix/.tmp"
# Specify categorical variables
cat_vars="sex,batch"
# Specify info filter
info=0.3
# Specify maf filter
maf=0.01
# Specify cluster partition name
partition=cpu
# Specify number of cpus for openmp parallelisation
cpus_openmp=15
# Specify number of splits for regenie level 1 split
n_split=8
EOF

	. $config_path && mkdir -p $gen $gtp ${phe%/*} $out $log $tmp

}

function set_env() {
	getnames_nosuf() {
		# Get file names without suffix
		local base_names=($(basename -a "$@" | cut -f1 -d. | sort -u))
		echo "${base_names[@]}"
	}

	gtp_base_name_arr=($(getnames_nosuf $gtp/*))

	if [ ${#gtp_base_name_arr[@]} -ne 1 ]; then
		error "There should be 1 genotype file."
	fi

	gen_base_names_arr=($(getnames_nosuf $gen/*))

	# Each gen_base_name shoud have exactly one occurence of the pattern chr[0-9][0-9]*
	for gn in $gen_base_names_arr; do
		if [ $(echo $gn | grep -o chr[0-9][0-9]* | wc -l) != 1 ]; then
			error "There should only be one occurence of pattern chr[0-9][0-9]* in a file name."
		fi
	done

	# Number of imputed genetic files should be 22
	# if [ ${#gen_base_names_arr[@]} != 22 ]; then
	# 	error "${#gen_base_names_arr[@]} chromosome files found. Should be 22"
	# fi
	#
	# Format gen file name for job array submission template
	gen_base_name_jobtem_arr=($(
		for n in ${gen_base_names_arr[@]}; do
			echo $n
		done |
			# for loop to print on different lines to sort
			sed 's/chr[0-9][0-9]*/chr${SLURM_ARRAY_TASK_ID}/' | sort -u
	))

	# Job array submission template should result to only one
	if [ ${#gen_base_name_jobtem_arr[@]} != 1 ]; then
		error "File names should be the same except for chromosome number."
	fi

	# File names should be the same except for chromosome number
	if [ ${#gen_base_name_jobtem_arr[@]} != 1 ]; then
		error "File names should be the same except for chromosome number."
	fi

	gtp_base_name=${gtp_base_name_arr[0]} # First element of an array
	gtp_path="$gtp/$gtp_base_name"
	gtp_out_path="$out/$gtp_base_name"

	gen_base_names=${gen_base_names_arr[@]}
	gen_base_name_jobtem=${gen_base_name_jobtem_arr[0]} # First element of an array
	gen_path="$gen/$gen_base_name_jobtem"
	gen_out_path="$out/$gen_base_name_jobtem"

	phes="$(head -1 $phe | awk '{$1="";$2="";print}' | sed 's/^ *//')"
	n_phes=$(($(head -1 $phe | awk '{print NF}') - 2))

	root=$(realpath $(dirname -- $0))

	alias sbatch_gwas='sbatch --parsable -p "$partition" --output $log/%x_%a_%j.out'
}

function run_model() {
	case $model in
	regenie-bt)
		jid1=$(sbatch_gwas --ntasks=$n_split --cpus-per-task=$cpus_openmp $root/lib/regenie-bt/regenie-bt-01.sh)
		jid_last=$(sbatch_gwas --dependency=afterok:$jid1 --cpus-per-task=$cpus_openmp --array=1-22 $root/lib/regenie-bt/regenie-bt-02.sh)
		jid_post_gwas=$(sbatch_gwas --dependency=afterok:$jid_last --ntasks=$n_phes --cpus-per-task=22 $root/lib/regenie-bt/regenie-bt-03.sh)
		;;
	regenie-qt)
		jid1=$(sbatch_gwas --ntasks=$n_split --cpus-per-task=$cpus_openmp $root/lib/regenie-qt/regenie-qt-01.sh)
		jid_last=$(sbatch_gwas --dependency=afterok:$jid1 --cpus-per-task=$cpus_openmp --array=1-22 $root/lib/regenie-qt/regenie-qt-02.sh)
		jid_post_gwas=$(sbatch_gwas --dependency=afterok:$jid_last --ntasks=$n_phes --cpus-per-task=22 $root/lib/regenie-qt/regenie-qt-03.sh)
		;;
	*)
		error 'Models should be one of "regenie-qt", "regenie-bt", "plink2-qt" or "plink-bt".'
		;;
	esac
}

function error() {
	# Log to stderr and exit with failure.
	printf "%s\n" "$1" >&2
	exit 1
}

function main() {
	if [ ${#} -eq 0 ]; then
		help
	fi
	while [ $# -gt 0 ]; do
		case "$1" in
		--help | -h)
			help && exit 0
			;;
		--init | -i)
			init && exit 0
			;;
		--config | -c)
			shift
			# Source config
			config=$1 && [ -f $config ] && . "$config"
			shift
			;;
		--model | -m)
			shift
			model=$1
			# If a file, load model from file
			[ ! -z $model -a -f $model ] && . $model && model=$(basename $model)
			shift
			;;
		--fresh | -f)
			find $log -type f -exec rm {} \;
			find $out -type f -exec rm {} \;
			shift
			;;
		*)
			error "$1 is not a recognized flag!"
			exit 1
			;;
		esac
	done

	set_env && run_model
}

main "$@"
