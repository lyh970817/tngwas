#!/bin/bash
set -a

function help() {
	cat <<EOF
Usage: $(
		basename "${BASH_SOURCE[0]}"
	) [-h] [-i] [PROJECT-NAME] -c [CONFIG-FILE] -m [DIRECTORY] [-f] 

tngwas is a simple and extensible pipeline for GWAS analyses. Check the
latest updates and usage guide at https://github.com/lyh970817/tngwas/.

Available options:

-h, --help      Print this help and exit
-i, --init      Generate default project directory structure in the current 
                directory, or in a specified project directory in the current 
                directory
-c, --config    Specify the config file
-p, --pipe      Specify the directory containing a pipeline template
-f, --fresh     Clean the LOG and OUT directories specified in CONFIG-FILE.
EOF
	exit
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
GEN="$path_prefix/gen"
# Specify path to genotype data file folder
GTP="$path_prefix/gtp"
# Specify path to phenotype file 
PHE="$path_prefix/phe/phe"
# Specify path to covariates file
COV="$path_prefix/phe/cov"
# Specify path to gwas output folder
OUT="$path_prefix/out"
# Specify path to log folder
LOG="$path_prefix/log"
# Specify path to tmp folder
TMP="$path_prefix/.tmp"
# Specify path to utils folder
UTILS="$path_prefix/utils"
# Specify directory to ldsc
LDSC=""
# Specify directory to ldsc snp list
SNP_LIST=""
# Specify directory to ldsc ld chr
LD_CHR=""
# Specify categorical variables
CAT_VARS="sex,batch"
# Specify info filter
INFO=0.3
# Specify maf filter
MAF=0.01
# Specify cluster partition name
PARTITION=cpu
# Specify number of cpus for openmp parallelisation
CPUS_OPENMP=15
# Specify number of cpus for openmp parallelisation
MEM_PER_CPU=2048M
# Specify number of splits for regenie level 1 split
N_SPLIT=8
EOF

	. $config_path && mkdir -p $GEN $GTP ${PHE%/*} $OUT $LOG $TMP

}

function set_env() {
	getnames_nosuf() {
		# Get file names without suffix
		local base_names=($(basename -a "$@" | cut -f1 -d. | sort -u))
		echo "${base_names[@]}"
	}

	gtp_base_name_arr=($(getnames_nosuf $GTP/*))

	if [ ${#gtp_base_name_arr[@]} -ne 1 ]; then
		error "There should be 1 genotype file."
	fi

	gen_base_names_arr=($(getnames_nosuf $GEN/*))

	# Each gen_base_name shoud have exactly one occurence of the pattern chr[0-9][0-9]*
	for gn in $gen_base_names_arr; do
		if [ $(echo $gn | grep -o chr[0-9][0-9]* | wc -l) != 1 ]; then
			error "There should only be one occurence of pattern chr[0-9][0-9]* in a file name."
		fi
	done

	# Number of imputed genetic files should be 22
	if [ ${#gen_base_names_arr[@]} != 22 ]; then
		error "${#gen_base_names_arr[@]} chromosome files found. Should be 22"
	fi

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

	SUBDIR="$(basename $PHE)_$(basename $COV)"
	OUT="$OUT/$SUBDIR"
	LOG="$LOG/$SUBDIR"
	mkdir -p $OUT $LOG

	if [[ $FRESH -eq 1 ]]; then
		find $LOG -type f -exec rm {} \;
		find $OUT -type f -exec rm {} \;
	fi

	GTP_BASE_NAME=${gtp_base_name_arr[0]} # First element of an array
	GTP_PATH="$GTP/$GTP_BASE_NAME"
	GTP_OUT_PATH="$OUT/$GTP_BASE_NAME"

	GEN_BASE_NAMES=${gen_base_names_arr[@]}
	GEN_BASE_NAME_JOBTEM=${gen_base_name_jobtem_arr[0]} # First element of an array
	GEN_PATH="$GEN/$GEN_BASE_NAME_JOBTEM"
	GEN_OUT_PATH="$OUT/$GEN_BASE_NAME_JOBTEM"

	PHES="$(head -1 $PHE | awk '{$1="";$2="";print}' | sed 's/^ *//')"
	N_PHES=$(($(head -1 $PHE | awk '{print NF}') - 2))
}

function run_pipe() {
	. "$PIPE"/"$(basename "$PIPE")".sbatch
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
			config="${1-}" && [ -f $config ] && . "$config"
			shift
			;;
		--pipe | -m)
			shift
			PIPE="${1-}"
			[ ! -d $PIPE ] && error "$PIPE is not a directory"
			shift
			;;
		--fresh | -f)
			FRESH=1
			shift
			;;
		-?*)
			error "$1 is not a recognized flag!"
			;;
		esac
	done

	set_env && run_pipe
}

main "$@"
