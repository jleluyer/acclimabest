#!/bin/bash
#PBS -N parse_fastqBT0
#PBS -o 98_log_files/parse.fq.BT0.out
#PBS -l walltime=02:00:00
#PBS -l mem=30g
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
base=BT0
DATAINPUT="03_trimmed"
DATAMAP="04_mapped/transcriptome"


# create list reads symbiont

samtools view "$DATAMAP"/"$base".sorted.bam|awk '{print $1}'|sort -u >list_"$base"

# Filter input reads
filterbyname.sh in="$DATAINPUT"/"$base".trimmed.fastq.gz out="$DATAINPUT"/"$base".symbiont.fastq.gz ow=t names=list_"$base" include=f
filterbyname.sh in="$DATAINPUT"/"$base".trimmed.fastq.gz out="$DATAINPUT"/"$base".host.fastq.gz ow=t names=list_"$base" include=t
