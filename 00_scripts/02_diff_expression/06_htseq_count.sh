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

# install htseq
. /appli/bioinfo/htseq/0.6.1/env.sh

#Global variables
DATAINPUT="04_mapped/diff_expression"
DATAOUTPUT="05_count"

GFF_FOLDER_host="/home1/datawork/jleluyer/00_ressources/transcriptomes/P_margaritifera"
GFF_FILE_host="Trinity.100aaorf.minexpr0.5.gff3"

#launch script
base=__BASE__

# for gene expression
htseq-count -f="bam" -s="no" -r="pos" -t="CDS" -i="Name" --mode="union" "$DATAINPUT"/"$base".host.sorted.bam "$GFF_FOLDER_host"/"$GFF_FILE_host" >>"$DATAOUTPUT"/htseq-count_"$base"_host.txt


GFF_FOLDER_symbiont="/home1/datawork/jleluyer/00_ressources/transcriptomes/P_margaritifera"
GFF_FILE_symbiont="Trinity.100aaorf.minexpr0.5.gff3"

#launch script
base=__BASE__

# for gene expression
htseq-count -f="bam" -s="no" -r="pos" -t="CDS" -i="Name" --mode="union" "$DATAINPUT"/"$base"symbiont.sorted.bam "$GFF_FOLDER_symbiont"/"$GFF_FILE_symbiont" >>"$DATAOUTPUT"/htseq-count_"$base"_symbiont.txt

