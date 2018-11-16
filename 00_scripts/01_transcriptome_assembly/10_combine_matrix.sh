#!/bin/bash
#PBS -N matrix
#PBS -o 98_log_files/matrix.out
#PBS -l walltime=20:00:00
#PBS -l mem=5g
#####PBS -m ea 
#PBS -l ncpus=1
#PBS -r n

cd $PBS_O_WORKDIR


#Global variables
DATAIN="07_de_results"		#path to abundance estimate files directory (isoforms.results files)

sample1="$DATAIN"/isoform.HI.4692.002.NEBNext_Index_11.38
sample2="$DATAIN"/isoform.HI.4692.002.NEBNext_Index_13.37
sample3="$DATAIN"/isoform.HI.4692.002.NEBNext_Index_20.39
sample4="$DATAIN"/isoform.HI.4692.002.NEBNext_Index_21.17
sample5="$DATAIN"/isoform.HI.4692.002.NEBNext_Index_2.20
sample6="$DATAIN"/isoform.HI.4692.002.NEBNext_Index_23.18
sample7="$DATAIN"/isoform.HI.4692.002.NEBNext_Index_27.19


abundance_estimates_to_matrix.pl --est_method RSEM --gene_trans_map none $sample1 $sample2 $sample3 $sample4 $sample5 $sample6 $sample7

