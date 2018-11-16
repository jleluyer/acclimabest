#!/bin/bash
#PBS -N annotation
#PBS -o 98_log_files/annotation.out
#PBS -l walltime=20:00:00
#PBS -l mem=30g
#PBS -l ncpus=16
#PBS -q omp
#PBS -r n

# module load


cd $PBS_O_WORKDIR

# Global variables
UNIPROT="00_ressources/uniprot/uniprot_sprot.fasta"


#makeblastdb -in $UNIPROT -input_type 'fasta' -dbtype 'prot'
TRANSCRIPTOME="08_trimmed_assembly/symbiont.transcriptome.fa"
cat $TRANSCRIPTOME | parallel -j 16 -k --block 10k --recstart '>' --pipe blastx -db $UNIPROT -query - -outfmt 6 -max_target_seqs 1 -evalue 1e-4 >09_annotation/blastx_symbiont_sprot_e-4.txt




TRANSCRIPTOME="08_trimmed_assembly/host.transcriptome.fa"
cat $TRANSCRIPTOME | parallel -j 16 -k --block 10k --recstart '>' --pipe blastx -db $UNIPROT -query - -outfmt 6 -max_target_seqs 1 -evalue 1e-4 >09_annotation/blastx_host_sprot_e-4.txt
