#!/bin/bash


# Clean past jobs

rm 00_scripts/datarmor_jobs/02_diff_expression/GSNAP_*sh


# launch scripts for Colosse
for file in $(ls 03_trimmed/diff_expression/*trimmed*.f*q.gz|sed -e 's/.symbiont.trimmed.fastq.gz//g'-e 's/.host.trimmed.fastq.gz//g' -e 's/_R[12]//g'|sort -u)
do

base=$(basename "$file")

	toEval="cat 00_scripts/02_diff_expression/03_gsnap_filtering.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/02_diff_expression/GSNAP_$base.sh
done

#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/02_diff_expression/GSNAP_*sh); do qsub $i; done


