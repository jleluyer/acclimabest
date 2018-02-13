#!/bin/bash


# Clean past jobs

rm 00_scripts/datarmor_jobs/GSNAP_*sh


# launch scripts for Colosse
for file in $(ls 03_trimmed/assembly/*trimmed*.f*q.gz|sed -e 's/.trimmed.fastq.gz//' -e 's/_R[12]//g'|sort -u)
do

base=$(basename "$file")

	toEval="cat 00_scripts/03_gsnap_filtering.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/GSNAP_$base.sh
done

#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/GSNAP_*sh); do qsub $i; done


