#!/bin/bash

# Clean up
rm 00_scripts/datarmor_jobs/06_metabarcoding/TRIM*sh

# launch scripts for Colosse
for file in $(ls /home1/scratch/jleluyer/acclimabest/03_trimmed/metabarcoding/*paired.fastq.gz|sed -e 's/_R[12].paired.fastq.gz//g'|sort -u)

do
	base=$(basename "$file")
	toEval="cat 00_scripts/06_metabarcoding/02_merge_pe.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/06_metabarcoding/TRIM_"$base".sh
done


#change jobs header

#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/06_metabarcoding/TRIM*sh); do qsub $i; done


