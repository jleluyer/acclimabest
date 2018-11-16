#!/bin/bash
#PBS -N gmap_index
#PBS -o gmap_index.out
#PBS -l walltime=24:00:00
#PBS -m ea 
#PBS -l ncpus=1
#PBS -l mem=30g
#PBS -r n

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

#move to present working dir
cd $PBS_O_WORKDIR

# Combined
## Host
GENOMEFOLDER="/home1/datawork/jleluyer/00_ressources/genomes/S_cladeC/"
FASTA="/home1/datawork/jleluyer/00_ressources/genomes/S_cladeC/SymbC1.Genome.Scaffolds.fasta"
GENOME="genome_symbC"

gmap_build --dir="$GENOMEFOLDER" "$FASTA" -d "$GENOME" 2> 98_log_files/log.index."$TIMESTAMP"

