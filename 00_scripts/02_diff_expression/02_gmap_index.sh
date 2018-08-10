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
GENOMEFOLDER="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/"
FASTA="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/combined.transcriptome.fa"
GENOME="combined.transcriptome"

gmap_build --dir="$GENOMEFOLDER" "$FASTA" -d "$GENOME" 2> 98_log_files/log.index."$TIMESTAMP"
exit
## Host
GENOMEFOLDER="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/"
FASTA="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/host.transcriptome.fa"
GENOME="host.transcriptome"

gmap_build --dir="$GENOMEFOLDER" "$FASTA" -d "$GENOME" 2> 98_log_files/log.index."$TIMESTAMP"

# Symbiont
FASTA="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/symbiont.transcriptome.fa"
GENOME="symbiont.transcriptome"

gmap_build --dir="$GENOMEFOLDER" "$FASTA" -d "$GENOME" 2> 98_log_files/log.index."$TIMESTAMP"

