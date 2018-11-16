#!/bin/bash
#PBS -N dada2qiime2
#PBS -o 98_log_files/qiime_dada2.out
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#####PBS -m ea 
#PBS -r n

cd $PBS_O_WORKDIR

# module load

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs paired-end-demux.qza \
  --o-table table-dada2.qza \
  --o-representative-sequences rep-seqs-dada2.qza \
  --p-trim-left-f 13 \
  --p-trim-left-r 13 \
  --p-trunc-len-f 250 \
  --p-trunc-len-r 250

mv rep-seqs-dada2.qza rep-seqs.qza
mv table-dada2.qza table.qza
