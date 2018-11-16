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
DATAINPUT="/scratch/home1/jleluyer/acclimabest/04_mapped/metanalysisi_c1"
DATAOUTPUT="05_count/metanalysis_c1"

GFF_FOLDER_symbiont="/home1/datawork/jleluyer/00_ressources/genomes/S_cladeC"
GFF_FILE_symbiont="SymbC1.Gene_Models.GFF3"

#launch script
base=__BASE__

# for gene expression
htseq-count -f "bam" -s "no" -t "gene" -i "ID" "$DATAINPUT"/"$base".symbiont.sorted.bam "$GFF_FOLDER_symbiont"/"$GFF_FILE_symbiont" >>"$DATAOUTPUT"/htseq-count_"$base".txt


