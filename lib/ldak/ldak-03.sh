#!/bin/bash

$LDAK --reml $OUT/reml_ldak --pheno $PHE --mgrm $TMP/ldak_mgrm.txt --max-threads $CPUS_OPENMP
