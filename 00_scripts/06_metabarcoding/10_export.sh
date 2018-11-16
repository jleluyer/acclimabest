#!/bin/bash
#PBS -N qiime2
#PBS -o 98_log_files/qiime_export.out
#PBS -l walltime=02:00:00
#PBS -l mem=60g
#####PBS -m ea 
#PBS -r n

cd $PBS_O_WORKDIR

# module load


# export biom file
qiime tools export table.qza --output-dir exported

qiime tools export taxonomy.qza --output-dir exported

cp exported/taxonomy.tsv biom-taxonomy.tsv

#change header
sed -i -e 's/Feature ID/#OTUID/g' -e 's/taxon/taxonomy/g' -e 's/Confidence/confidence/g' biom-taxonomy.tsv

biom add-metadata -i exported/feature-table.biom -o table-with-taxonomy.biom --observation-metadata-fp biom-taxonomy.tsv --sc-separated taxonomy
