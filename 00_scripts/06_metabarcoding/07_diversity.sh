#!/bin/bash
#PBS -N sumqiime2
#PBS -o 98_log_files/qiime_diversity.out
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#####PBS -m ea 
#PBS -r n

cd $PBS_O_WORKDIR

# module load

# Prior check sampling depth in https://view.qiime2.org/

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 448 \
  --m-metadata-file 01_info_files/sample_metadata_acclimabest.tsv \
  --output-dir core-metrics-results
