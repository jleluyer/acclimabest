#!/bin/bash

for base in $(cat 01_info_files/files_accession.txt|awk '{print $1}'|grep -iv "model")

do 

	toEval="cat 00_scripts/utility_scripts/fastq-dump_all.sh | sed 's/__BASE__/$base/g'"; eval $toEval > FSTQ"$base".sh

done

for i in $(ls FSTQ*); do qsub $i; done
