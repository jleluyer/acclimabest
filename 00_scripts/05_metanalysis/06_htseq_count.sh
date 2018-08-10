#!/usr/bin/env bash
#PBS -N htseq.__BASE__
#PBS -o 98_log_files/htseq.__BASE__.err
#PBS -l walltime=10:00:00
#PBS -m ea
#PBS -l ncpus=1
#PBS -l mem=50g
#PBS -r n


# Move to present working dir
cd $PBS_O_WORKDIR


#Global variables
DATAINPUT="/scratch/home1/jleluyer/acclimabest/04_mapped/metanalysis"
DATAOUTPUT="05_count/metanalysis"

GFF_FOLDER_symbiont="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly"
GFF_FILE_symbiont="symbiont.gff"

#launch script
base=__BASE__

# for gene expression
htseq-count -f "bam" -s "no" -t "CDS" -i "Name" "$DATAINPUT"/"$base".symbiont.sorted.bam "$GFF_FOLDER_symbiont"/"$GFF_FILE_symbiont" >>"$DATAOUTPUT"/htseq-count_"$base".txt


