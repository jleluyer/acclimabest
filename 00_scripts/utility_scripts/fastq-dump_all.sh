#!/bin/bash
#PBS -N import
#PBS -o 98_log_files/import.dataset.out
#PBS -l walltime=20:00:00
#PBS -l mem=10g
#PBS -l ncpus=1
#PBS -r n

cd $PBS_O_WORKDIR


for i in $(cat 01_info_files/files_accession.txt|awk '{print $1}'|grep -iv "model")

do 

fastq-dump --gzip --split-files --outdir "02_data/assembly/" $i

done
