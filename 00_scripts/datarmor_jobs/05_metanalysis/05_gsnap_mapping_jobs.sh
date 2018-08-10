#!/bin/bash


# Clean past jobs

rm 00_scripts/datarmor_jobs/05_metanalysis/GSNAP_*sh


# launch scripts for Colosse
for file in $(ls /scratch/home1/jleluyer/acclimabest/03_trimmed/metanalysis/*trimmed*.f*q.gz|sed 's/.trimmed.fastq.gz//g' |sort -u)
do

base=$(basename "$file")

	toEval="cat 00_scripts/05_metanalysis/05_gsnap_mapping.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/05_metanalysis/GSNAP_"$base".sh
done

#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/05_metanalysis/GSNAP_*sh); do qsub $i; done


