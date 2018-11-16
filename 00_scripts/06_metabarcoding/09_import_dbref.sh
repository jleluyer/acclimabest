#!/bin/bash
#PBS -N sumqiime2
#PBS -o 98_log_files/qiime_importref.out
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#####PBS -m ea 
#PBS -r n

cd $PBS_O_WORKDIR

# module load

#import ref.fasta + taxonomy
qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path 01_info_files/sequence_otu_trimmed.fa \
  --output-path ref-otus.qza

qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --source-format HeaderlessTSVTaxonomyFormat \
  --input-path 01_info_files/id_taxonomy.txt \
  --output-path ref-taxonomy.qza

#extract specific regions
qiime feature-classifier extract-reads \
  --i-sequences ref-otus.qza \
  --p-f-primer GTGAATTGCAGAACTCCGTG \
  --p-r-primer CCTCCGCTTACTTATATGCTT \
  --o-reads ref-seq.qza

#classifier
qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads ref-seq.qza \
  --i-reference-taxonomy ref-taxonomy.qza \
  --o-classifier classifier.qza

#test classifier
qiime feature-classifier classify-sklearn \
  --i-classifier classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza

qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv

#visualization
qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file 01_info_files/sample_metadata_acclimabest.tsv \
  --o-visualization taxa-bar-plots.qzv

