#!/bin/bash

# Clean up
rm 00_scripts/datarmor_jobs/01_transcriptome_assembly/TRIM*sh

# launch scripts for Colosse
for file in $(ls 02_data/*fastq.gz|sed -e 's/_R[12].fastq.gz//'|sort -u)

do
	base=$(basename "$file")
	toEval="cat 00_scripts/01_transcriptome_assembly/01_trimmomatic_pe.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/01_transcriptome_assembly/TRIM_"$base".sh
done


#change jobs header

#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/01_transcriptome_assembly/TRIM*sh); do qsub $i; done


