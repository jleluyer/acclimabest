#!/bin/bash

for file in $(ls 05_count/metanalysis_c1/htseq*)
do
	base=$(basename "$file")
	echo -e "genes\t$base" | cat - $file > $file.temp
        mv $file.temp "$file".trim
done
