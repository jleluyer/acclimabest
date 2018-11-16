#!/bin/bash


# Clean past jobs

rm 00_scripts/datarmor_jobs/05_metanalysis/HTSQ_*sh

for i in $(ls 04_mapped/metanalysisi_c1/*symbiont.sorted.bam|sed -e 's/.symbiont.sorted.bam//g'|sort -u)

do
base="$(basename $i)"

	toEval="cat 00_scripts/05_metanalysis/06_htseq_count.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/05_metanalysis/HTSQ_$base.sh
done


#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/05_metanalysis/HTSQ_*sh); do qsub $i; done


