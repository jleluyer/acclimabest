#!/bin/bash
#PBS -N trimmomatic__BASE__
#PBS -o 98_log_files/trimmomatic.__BASE__.out
#PBS -l walltime=02:00:00
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

. /appli/bioinfo/trimmomatic/0.36/env.sh

# Global variables

ADAPTERFILE="/home1/datawork/jleluyer/00_ressources/univec/univec.fasta"
NCPU=8
base=__BASE__

trimmomatic SE -Xmx60G \
        -phred33 \
        02_data/assembly/"$base".fastq.gz \
        03_trimmed/assembly/"$base".trimmed.fastq.gz \
        ILLUMINACLIP:"$ADAPTERFILE":2:20:7 \
        LEADING:20 \
        TRAILING:20 \
        SLIDINGWINDOW:30:30 \
        MINLEN:60 2>&1 | tee 98_log_files/"$TIMESTAMP"_trimmomatic_"$base".log
