#!/bin/bash


# Clean past jobs

rm 00_scripts/datarmor_jobs/01_transcritome_assembly/CLN_*sh

for i in $(ls /scratch/home1/jleluyer/acclimabest/04_mapped_assembly/*nomapping|sed -e 's/.nomapping//g')

do
base="$(basename $i)"

	toEval="cat 00_scripts/01_transcriptome_assembly/04_clean_dataset.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/01_transcriptome_assembly/CLN_"$base".sh
done


#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/01_transcriptome_assembly/CLN_*sh); do qsub $i; done


