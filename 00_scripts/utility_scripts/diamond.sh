#!/bin/bash
#PBS -N diamond
#PBS -o diamond.out
#PBS -l walltime=20:00:00
#PBS -l mem=30g
#PBS -l ncpus=16
#PBS -q omp
#PBS -r n

# module load


cd $PBS_O_WORKDIR

# Global variables
UNIPROT="00_ressources/uniprot/uniprot_sprot.fasta"
TRANSCRIPTOME="08_trimmed_assembly/symbiont.transcriptome.fa"

#diamond makedb --in $UNIPROT -d uniprot_diamond

diamond blastx --more-sensitive -d uniprot_diamond -p 16 -q $TRANSCRIPTOME -f 6 -k 1 -e 1e-4 -o 09_annotation/diamond_symbiont_sprot_e-4.txt

TRANSCRIPTOME="08_trimmed_assembly/host.transcriptome.fa"

diamond blastx --more-sensitive -d uniprot_diamond -p 16 -q $TRANSCRIPTOME -f 6 -k 1 -e 1e-4 -o 09_annotation/diamond_host_sprot_e-4.txt
