#!/bin/bash
#PBS -N parse_fastq__BASE__
#PBS -o 98_log_files/parse.fq.__BASE__.out
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
base=__BASE__
DATAINPUT="03_trimmed/diff_expression"
DATAMAP="04_mapped/diff_expression"


# create list reads symbiont

samtools view "$DATAMAP"/"$base".mapped.bam|awk '{print $1}'|sort -u >list_symbiont_"$base"

# Filter input reads symbiont
filterbyname.sh in="$DATAINPUT"/"$base".trimmed.fastq.gz out="$DATAINPUT"/"$base".host.fastq.gz ow=t names=list_symbiont_"$base" include=f


# create list reads host
samtools view "$DATAMAP"/"$base".unmapped.bam|awk '{print $1}'|sort -u >list_host_"$base"

# Filter input reads host
filterbyname.sh in="$DATAINPUT"/"$base".trimmed.fastq.gz out="$DATAINPUT"/"$base".symbiont.fastq.gz ow=t names=list_host_"$base" include=f
