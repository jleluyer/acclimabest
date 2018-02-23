#!/bin/bash
#PBS -N import
#PBS -o 98_log_files/import.__BASE__.out
#PBS -l walltime=20:00:00
#PBS -l mem=10g
#PBS -l ncpus=1
#PBS -r n

cd $PBS_O_WORKDIR


base=__BASE__

fastq-dump --gzip --split-files --outdir "02_data/assembly/" $base

