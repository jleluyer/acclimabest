#!/bin/bash
#PBS -N merge
#PBS -o 98_log_files/log-merge.out
#PBS -l walltime=02:00:00
#PBS -l mem=10g
#PBS -r n

cd $PBS_O_WORKDIR


TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

. /appli/bioinfo/samtools/latest/env.sh

# Tools dependencies BBmap


# Global variables
base=__BASE__
FOLDER="03_trimmed/assembly"

#cat all reads
	cat "$FOLDER"/*_R1.paired.fastq.gz > "$FOLDER"/all_reads.left.fastq.gz
 
	cat "$FOLDER"/*_R2.paired.fastq.gz > "$FOLDER"/all_reads.right.fastq.gz
