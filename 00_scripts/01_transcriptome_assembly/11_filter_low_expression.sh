#!/bin/bash
#PBS -N matrix
#PBS -o 98_log_files/filtermatrix.out
#PBS -l walltime=20:00:00
#PBS -l mem=5g
#####PBS -m ea 
#PBS -l ncpus=1
#PBS -r n

cd $PBS_O_WORKDIR

#Global variables
#ASSEMBLY="05_trinity_assembly/05_trinity_assembly_200.Trinity.fasta"		#path to transcriptome assembly
ASSEMBLY="05_trinity_assembly/raw.trinity.fasta"
MATRIX="07_de_results/RSEM.isoform.TPM.not_cross_norm"			#path to abundance matrix (matrix.TPM.not_cross_norm file)

#Trinity variables

#OUTPUT="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/filter_low_expression_transcripts.fa"

OUTPUT="08_trimmed_assembly/filter_low_expression_stats_and_orfs.fa"


#Global variables
MIN_EXPR=0.5
DATAIN="07_de_results"

filter_low_expr_transcripts.pl --transcripts $ASSEMBLY --matrix $MATRIX --highest_iso_only --min_expr_any $MIN_EXPR --trinity_mode > $OUTPUT

#TrinityStats.pl $OUTPUT >06_assembly_stats/filter_low_expression_stats.txt

TrinityStats.pl $OUTPUT >06_assembly_stats/filter_low_expression.stats
