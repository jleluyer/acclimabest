#!/bin/bash
#PBS -N blastn
#PBS -o blastn_conta.out
#PBS -l walltime=20:00:00
#PBS -l mem=30g
#PBS -l ncpus=16
#PBS -q omp
#PBS -r n

. /appli/bioinfo/blast/2.6.0/env.sh


cd $PBS_O_WORKDIR

# Global variables
DB="/home1/datawork/jleluyer/00_ressources/genomes/S_cladeC/SymbC1.Genome.Scaffolds.fasta"
TRANSCRIPTOME="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/final.assembly.fa"

makeblastdb -in $DB -input_type 'fasta' -dbtype 'nucl'

cat $TRANSCRIPTOME | parallel -j 16 -k --block 10k --recstart '>' --pipe blastn -db $DB -query - -outfmt 6 -max_target_seqs 4 -evalue 1e-4 >blastn_transcriptome_genomesymbioC_e-4.maxtarget4.txt

