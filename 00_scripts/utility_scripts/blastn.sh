#!/bin/bash
#PBS -N blastn
#PBS -o blastn_fucata.out
#PBS -l walltime=20:00:00
#PBS -l mem=30g
#PBS -l ncpus=16
#PBS -q omp
#PBS -r n

. /appli/bioinfo/blast/2.6.0/env.sh


cd $PBS_O_WORKDIR

# check conta
SYMBIOSP="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/Symbiodinium-sp-C1.nt.fa"

cat $TRANSCRIPTOME| parallel -j 16 -k --block 10k --recstart '>' --pipe blastn -db $SYMBIOSP -query - -outfmt 6 -max_target_seqs 4 -evalue 1e-4 >blastn_transcriptome_symbiodinium_e-4.maxtarget4.txt
