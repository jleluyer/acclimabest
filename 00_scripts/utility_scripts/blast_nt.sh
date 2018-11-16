#!/bin/bash
#PBS -N blastn
#PBS -o 98_log_files/blastn.annotation.nt.out
#PBS -l walltime=50:00:00
#PBS -l mem=50g
#PBS -l ncpus=5
#PBS -q omp
#PBS -r n

cd $PBS_O_WORKDIR

# module load

# Global variables
TAX_FORMAT="6 qseqid sseqid pident length staxids sscinames scomnames sblastnames sskingdoms evalue bitscore"
QUERY="host_gc50.fa"
NCPUS=5

BANK=/home/nt

#jobs
#cat "$QUERY"  |parallel -j "$NCPUS" -k --block 10k --recstart '>' --pipe blastn -db $BANK -query - -outfmt \"$TAX_FORMAT\" -max_target_seqs 5 -evalue 1e-4 >blast_annotation_hostgc50_nt.txt

QUERY="08_trimmed_assembly/host.transcriptome.fa"
#jobs
cat "$QUERY"  |parallel -j "$NCPUS" -k --block 10k --recstart '>' --pipe blastn -db $BANK -query - -outfmt \"$TAX_FORMAT\" -max_target_seqs 5 -evalue 1e-6 >blast_annotation_host_nt.txt


QUERY="08_trimmed_assembly/symbiont.transcriptome.fa"
#jobs
cat "$QUERY"  |parallel -j "$NCPUS" -k --block 10k --recstart '>' --pipe blastn -db $BANK -query - -outfmt \"$TAX_FORMAT\" -max_target_seqs 5 -evalue 1e-6 >blast_annotation_symbiont_nt.txt
