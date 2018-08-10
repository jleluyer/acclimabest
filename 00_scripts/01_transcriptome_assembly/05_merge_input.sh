#!/bin/bash
#PBS -N merge
#PBS -o 98_log_files/log-merge.out
#PBS -l walltime=02:00:00
#PBS -l mem=50g
#PBS -r n

cd $PBS_O_WORKDIR

# Global variables
FOLDER="/scratch/home1/jleluyer/acclimabest/03_trimmed/assembly"

#cat all reads
	cat "$FOLDER"/*_R2.paired.fastq.gz > "$FOLDER"/combined_R2.fastq.gz
 	cat "$FOLDER"/*_R1.paired.fastq.gz > "$FOLDER"/combined_R1.fastq.gz

#	cat "$FOLDER"/*symbiont.fastq.gz > "$FOLDER"/symbiont.fastq.gz
