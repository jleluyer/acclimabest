#!/bin/bash
#PBS -N blastn
#PBS -o 98_log_files/blastn.annotation.nt.out
#PBS -l walltime=50:00:00
#PBS -l mem=50g
#PBS -l ncpus=5
#PBS -q omp
#PBS -r n

cd $PBS_O_WORKDIR


# Module load

. /appli/bioinfo/blast/2.6.0/env.sh

# Global variables
TAX_FORMAT="6 qseqid sseqid pident length staxids sscinames scomnames sblastnames sskingdoms evalue bitscore"
QUERY="host_gc50.fa"
NCPUS=5

BANK=/home/ref-bioinfo/beedeem/n/NCBI_nt/current/NCBI_nt/nt

# Ou se trouve la taxo de NBCI nt ?
export BLASTDB=/home/ref-bioinfo/beedeem/n/NCBI_nt/current/NCBI_nt

#jobs
#cat "$QUERY"  |parallel -j "$NCPUS" -k --block 10k --recstart '>' --pipe blastn -db $BANK -query - -outfmt \"$TAX_FORMAT\" -max_target_seqs 5 -evalue 1e-4 >blast_annotation_hostgc50_nt.txt

QUERY="08_trimmed_assembly/host.transcriptome.fa"
#jobs
cat "$QUERY"  |parallel -j "$NCPUS" -k --block 10k --recstart '>' --pipe blastn -db $BANK -query - -outfmt \"$TAX_FORMAT\" -max_target_seqs 5 -evalue 1e-6 >blast_annotation_host_nt.txt


QUERY="08_trimmed_assembly/symbiont.transcriptome.fa"
#jobs
cat "$QUERY"  |parallel -j "$NCPUS" -k --block 10k --recstart '>' --pipe blastn -db $BANK -query - -outfmt \"$TAX_FORMAT\" -max_target_seqs 5 -evalue 1e-6 >blast_annotation_symbiont_nt.txt

#BANK="/home/ref-bioinfo/beedeem/p/NCBI_nr_blast/download/NCBI_nr_blast/nr"
#export BLASTDB=/home/ref-bioinfo/beedeem/p/NCBI_nr_blast/download/NCBI_nr_blast/nr
#jobs
#cat "$QUERY"  |parallel -j "$NCPUS" -k --block 10k --recstart '>' --pipe blastx -db $BANK -query - -outfmt \"$TAX_FORMAT\" -max_target_seqs 5 -evalue 1e-6 >blast_annotation_hostgc50_nr.txt
