#!/bin/bash
#PBS -N trimmomatic__BASE__
#PBS -o trimmomatic__BASE__.out
#PBS -l walltime=20:00:00
#PBS -l mem=60g
#####PBS -m ea 
#PBS -l ncpus=8
#PBS -q omp
#PBS -r n

cd $PBS_O_WORKDIR


TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# modul load

# Global variables

DATAOUT="/scratch"
ADAPTERFILE="univec.fasta"
NCPU=8
base=__BASE__

trimmomatic SE -Xmx60G \
        -phred33 \
        "$DATAOUT"/02_data/metanalysis/"$base"_1.fastq.gz \
        "$DATAOUT"/03_trimmed/metanalysis/"$base".trimmed.fastq.gz \
        ILLUMINACLIP:"$ADAPTERFILE":2:20:7 \
        LEADING:20 \
        TRAILING:20 \
        SLIDINGWINDOW:30:30 \
        MINLEN:40 2>&1 | tee 98_log_files/"$TIMESTAMP"_trimmomatic_"$base".log
