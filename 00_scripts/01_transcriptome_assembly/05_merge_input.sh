#!/bin/bash
#PBS -N merge
#PBS -o 98_log_files/log-merge.out
#PBS -l walltime=02:00:00
#PBS -l mem=10g
#PBS -r n

cd $PBS_O_WORKDIR

# Global variables
FOLDER="03_trimmed/assembly"

#cat all reads
	cat "$FOLDER"/*host.fastq.gz > "$FOLDER"/host.fastq.gz
 
	cat "$FOLDER"/*symbiont.fastq.gz > "$FOLDER"/symbiont.fastq.gz
