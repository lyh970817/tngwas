#!/bin/bash

sumstats_files=$(awk -v out=$sumstat_path_name '{print out"_"$1".regenie" }' ${out_path_name}_pred.list)
out_files=($(awk -v out=$out_path_name '{print out"_"$1".regenie" }' ${out_path_name}_pred.list))

for f in $sumstats_files;do
    touch $f
done

for (( i = 0; i < ${#sumstats_files[@]}; i++ )); do
   cat ${out_files[i]} >> ${sumstats_files[i]}
done

rm ${out_path_name}_split.master
rm ${out_path_name}_*.loco.*
rm ${out_path_name}_pred.list


