#!/bin/bash

# How dow this partiioning work? Can we calcualte for each chromosome separately without merging first?
$LDAK --add-grm $OUT/ldak_grm --mgrm $TMP/ldak_mgrm.txt --max-threads $CPUS_OPENMP

$LDAK --filter $OUT/ldak_grm_filtered --grm $OUT/ldak_grm --max-threads $CPUS_OPENMP
