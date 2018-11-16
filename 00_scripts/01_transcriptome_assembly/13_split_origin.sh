#!/bin/bash
#PBS -N blastx
#PBS -o blastx.out
#PBS -l walltime=20:00:00
#PBS -l mem=30g
#PBS -l ncpus=16
#PBS -q omp
#PBS -r n

. /appli/bioinfo/blast/2.6.0/env.sh


cd $PBS_O_WORKDIR

# Global variables
DB="01_info_files/pool.genome.transcriptome.fa"
TRANSCRIPTOME="08_trimmed_assembly/filtexp0.5_orf.fa"


#makeblastdb -in $DB -input_type 'fasta' -dbtype 'nucl'

cat $TRANSCRIPTOME | parallel -j 16 -k --block 10k --recstart '>' --pipe blastn -db $DB -query - -outfmt 6 -max_target_seqs 1 -evalue 1e-4 >blastn_host_poolsymbio.e-4.txt
