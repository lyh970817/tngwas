#!/bin/bash

gen_path_array_id=$(eval echo $GEN_PATH)
gen_out_path_array_id=$(eval echo $GEN_OUT_PATH)

$LDAK --calc-kins-direct $gen_out_path_array_id --bfile $gen_path_array_id --power -.25 --max-threads $CPUS_OPENMP

echo $gen_out_path_array_id >>$TMP/ldak_mgrm.txt
