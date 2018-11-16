#!/bin/bash
#PBS -N importqiime2
#PBS -o 98_log_files/qiime_import.out
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#####PBS -m ea 
#PBS -r n

cd $PBS_O_WORKDIR

. /appli/bioinfo/qiime/latest/env.sh

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path 01_info_files/pe-64-manifest-acclimabest \
  --output-path paired-end-demux.qza \
  --source-format PairedEndFastqManifestPhred33
