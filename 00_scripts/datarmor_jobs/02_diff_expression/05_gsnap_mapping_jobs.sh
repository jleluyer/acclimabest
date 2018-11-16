#!/bin/bash


# Clean past jobs

rm 00_scripts/datarmor_jobs/02_diff_expression/GSNAP_*sh


# launch scripts for Colosse
for file in $(ls 03_trimmed/corals/*paired*.f*q.gz|grep -v "36"|sed -e 's/.paired.fastq.gz//g' -e 's/_R[12]//g'|sort -u)
do

base=$(basename "$file")

	toEval="cat 00_scripts/02_diff_expression/05_gsnap_mapping.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/02_diff_expression/GSNAP_$base.sh
done

#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/02_diff_expression/GSNAP_*sh); do qsub $i; done


