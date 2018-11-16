#!/bin/bash
#PBS -N blastp
#PBS -o 98_log_files/blastp.c1.out
#PBS -l walltime=80:00:00
#PBS -l mem=30g
#PBS -l ncpus=8
#PBS -q omp
#PBS -r n

cd $PBS_O_WORKDIR


# Module load

. /appli/bioinfo/blast/2.6.0/env.sh

# Global variables
NCPUS=16
QUERY="/home1/datawork/jleluyer/00_ressources/genomes/S_cladeC/SymbC1.Gene_Models.PEP.fasta"


BANK="/home/ref-bioinfo/beedeem/p/Uniprot_SwissProt/current/Uniprot_SwissProt/Uniprot_SwissProt"

export BLASTDB=/home/ref-bioinfo/beedeem/p/Uniprot_SwissProt/current/Uniprot_SwissProt/Uniprot_SwissProt

#jobs
cat "$QUERY"  |parallel -j "$NCPUS" -k --block 10k --recstart '>' --pipe blastp -db $BANK -query - -outfmt 6 -max_target_seqs 5 -evalue 1e-4 >go_enrichment_c1/04_blast_results/blast_uniprot_c1.txt
