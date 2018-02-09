#!/bin/bash

# Clean up
rm 00_scripts/datarmor_jobs/PARSE*sh

# launch scripts for Colosse
for file in $(ls 03_trimmed/*.trimmed.fastq.gz|perl -pe 's/.trimmed.f(ast)?q.gz//'|sort -u)

do
	base=$(basename "$file")
	toEval="cat 00_scripts/utility_scripts/remove_list_reads_fastq.sh | sed 's/__BASE__/$base/g'"; eval $toEval > 00_scripts/datarmor_jobs/PARSE_"$base".sh
done


#change jobs header

#Submit jobs
for i in $(ls 00_scripts/datarmor_jobs/PARSE*sh); do qsub $i; done


