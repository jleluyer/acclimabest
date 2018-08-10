#!/bin/bash


# Clean past jobs

rm 00_scripts/datarmor_jobs/01_transcriptome_assembly/ABD_*sh


# launch scripts for Colosse
for file in $(ls /scratch/home1/jleluyer/acclimabest/03_trimmed/assembly/*paired.fastq.gz|sed -e 's/.paired.fastq.gz//' -e 's/_R[12]//g'|sort -u)
do

base=$(basename "$file")

	toEval="cat 00_scripts/01_transcriptome_assembly/09_transcripts_abundance.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/01_transcriptome_assembly/ABD_$base.sh
done

#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/01_transcriptome_assembly/ABD_*sh); do qsub $i; done


