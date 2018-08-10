#!/bin/bash

# Clean up
rm 00_scripts/datarmor_jobs/02_diff_expression/TRIM_*sh

# launch scripts for Colosse
for file in $(ls 02_data/diff_expression/*fastq.gz|sed -e 's/_R[12]//g' -e 's/.fastq.gz//'|sort -u)

do
	base=$(basename "$file")
	toEval="cat 00_scripts/02_diff_expression/01_trimmomatic_pe.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/02_diff_expression/TRIM_"$base".sh
done


#change jobs header

#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/02_diff_expression/TRIM_*sh); do qsub $i; done


