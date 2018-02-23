#!/bin/bash


# Clean past jobs

rm 00_scripts/datarmor_jobs/01_transcritome_02_diff_expression/CLN_*sh

for i in $(ls 04_mapped/diff_expression/*.bam|sed -e 's/.unmapped.bam//g' -e 's/.mapped.bam//g')

do
base="$(basename $i)"

	toEval="cat 00_scripts/02_diff_expression/04_clean_dataset.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/02_diff_expression/CLN_$base.sh
done


#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/02_diff_expression/CLN*sh); do qsub $i; done


