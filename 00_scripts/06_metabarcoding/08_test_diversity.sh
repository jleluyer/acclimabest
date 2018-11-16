#!/bin/bash
#PBS -N sumqiime2
#PBS -o 98_log_files/qiime_testdiversity.out
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#####PBS -m ea 
#PBS -r n

cd $PBS_O_WORKDIR

# module load

# Prior check sampling depth in https://view.qiime2.org/

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file 01_info_files/sample_metadata_acclimabest.tsv \
  --o-visualization core-metrics-results/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results/evenness_vector.qza \
  --m-metadata-file 01_info_files/sample_metadata_acclimabest.tsv \
  --o-visualization core-metrics-results/evenness-group-significance.qzv

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file 01_info_files/sample_metadata_acclimabest.tsv \
  --m-metadata-category Temperature \
  --o-visualization core-metrics-results/unweighted-unifrac-temperature-site-significance.qzv \
  --p-pairwise

qiime diversity beta-group-significance \
  --i-distance-matrix core-metrics-results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file 01_info_files/sample_metadata_acclimabest.tsv \
  --m-metadata-category Time \
  --o-visualization core-metrics-results/unweighted-unifrac-time-group-significance.qzv \
  --p-pairwise

#check p max https://view.qiime2.org/ with table.qzv and chekc median freq
qiime diversity alpha-rarefaction \
  --i-table table.qza \
  --i-phylogeny rooted-tree.qza \
  --p-max-depth 732 \
  --m-metadata-file 01_info_files/sample_metadata_acclimabest.tsv \
  --o-visualization alpha-rarefaction.qzv
