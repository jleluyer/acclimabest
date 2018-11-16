#!/bin/bash
#PBS -A userID
#PBS -N makegff
#PBS -o makegff.out
#PBS -e makegff.err
#PBS -l walltime=20:00:00
#PBS -M userEmail
#PBS -m ea 
#PBS -l nodes=1:ppn=8
#PBS -r n

# Move to job submission directory
cd $PBS_O_WORKDIR

#Global variables
chado_test/chado/bin/gmod_fasta2gff3.pl --fasta_dir sequence.fasta --gfffilename sequence.gff --type CDS --nosequence

