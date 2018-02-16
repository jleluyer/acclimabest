#!/bin/bash
#PBS -N gsnap.de.__BASE__
#PBS -o gsnap.de.__BASE__.err
#PBS -l walltime=23:00:00
#PBS -l mem=30g
#####PBS -m ea
#PBS -l ncpus=12
#PBS -q omp
#PBS -r n


. /appli/bioinfo/samtools/1.4.1/env.sh

# Global variables
DATAOUTPUT="04_mapped/diff_expression"
DATAINPUT="03_trimmed/diff_expression"

# For transcriptome
GENOMEFOLDER="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/gmap_symbiodiniumspC1"
GENOME="gmap_symbiodiniumspC1"

platform="Illumina"

#move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__

    # Align reads
    echo "Aligning $base"

    gsnap --gunzip -t 12 -A sam \
	--dir="$GENOMEFOLDER" -d "$GENOME" \
        -o "$DATAOUTPUT"/"$base" \
	--max-mismatches=5 --novelsplicing=1 \
	--read-group-id="$base" \
	 --read-group-platform="$platform" \
	"$DATAINPUT"/"$base".trimmed.fastq.gz
#--split-output="$DATAOUTPUT"/"$base" \    

# Create bam file
    echo "Creating bam for $base"
    samtools view -Sb -F 4 \
        "$DATAOUTPUT"/"$base".sam >"$DATAOUTPUT"/"$base".mapped.bam

	samtools view -Sb -f 4 \
        "$DATAOUTPUT"/"$base".sam >"$DATAOUTPUT"/"$base".unmapped.bam	
    
# Clean up
