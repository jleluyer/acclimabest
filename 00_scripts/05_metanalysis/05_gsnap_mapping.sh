#!/bin/bash
#PBS -N gsnap.trans.__BASE__
#PBS -o gsnap.trans.__BASE__.err
#PBS -l walltime=24:00:00
#PBS -l mem=50g
#####PBS -m ea
#PBS -l ncpus=12
#PBS -q omp
#PBS -r n


. /appli/bioinfo/samtools/1.4.1/env.sh

# Global variables
DATAOUTPUT="/scratch/home1/jleluyer/acclimabest/04_mapped/metanalysis"
DATAINPUT="/scratch/home1/jleluyer/acclimabest/03_trimmed/metanalysis"


# For transcriptome
GENOMEFOLDER_symbiont="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/"
GENOME_symbiont="symbiont.transcriptome"

GENOMEFOLDER_host="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/"
GENOME_host="host.transcriptome"


platform="Illumina"

#move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__

####################################################################
################## symbiont ########################################
####################################################################
    # Align reads
    echo "Aligning $base"

    gsnap --gunzip -t 12 -A sam \
	--dir="$GENOMEFOLDER_symbiont" -d "$GENOME_symbiont" \
        -o "$DATAOUTPUT"/"$base".symbiont.sam \
	--max-mismatches=5 --novelsplicing=1 \
	--read-group-id="$base" \
	 --read-group-platform="$platform" \
	"$DATAINPUT"/"$base".trimmed.fastq.gz
    
# Create bam file
    echo "Creating bam for $base"
    samtools view -Sb -q 5 -F 4 \
        "$DATAOUTPUT"/"$base".symbiont.sam >"$DATAOUTPUT"/"$base".symbiont.bam
	
     echo "Creating sorted bam for $base"
	samtools sort -n "$DATAOUTPUT"/"$base".symbiont.bam -o "$DATAOUTPUT"/"$base".symbiont.sorted.bam
    	samtools index "$DATAOUTPUT"/"$base".symbiont.sorted.bam


####################################################################
################## host ###########################################
####################################################################


    # Align reads
    echo "Aligning $base"

    gsnap --gunzip -t 12 -A sam \
        --dir="$GENOMEFOLDER_host" -d "$GENOME_host" \
        -o "$DATAOUTPUT"/"$base".host.sam \
        --max-mismatches=5 --novelsplicing=1 \
        --read-group-id="$base" \
         --read-group-platform="$platform" \
        "$DATAINPUT"/"$base".trimmed.fastq.gz

# Create bam file
    echo "Creating bam for $base"
    samtools view -Sb -q 5 -F 4 \
        "$DATAOUTPUT"/"$base".host.sam >"$DATAOUTPUT"/"$base".host.bam

     echo "Creating sorted bam for $base"
        samtools sort -n "$DATAOUTPUT"/"$base".host.bam -o "$DATAOUTPUT"/"$base".host.sorted.bam
        samtools index "$DATAOUTPUT"/"$base".host.sorted.bam
