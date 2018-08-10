#!/bin/bash

# Clean up
rm 00_scripts/datarmor_jobs/05_metanalysis/TRIM_*sh

# launch scripts for Colosse
for file in $(cat 01_info_files/list.metanalysis.txt)

do
	base=$(basename "$file")
	toEval="cat 00_scripts/05_metanalysis/01_trimmomatic_se.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/05_metanalysis/TRIM_"$base".sh
done


#change jobs header

#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/05_metanalysis/TRIM_*sh); do qsub $i; done


