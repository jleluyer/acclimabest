#!/bin/bash
#PBS -N gsnap.__BASE__
#PBS -o 98_log_files/gsnap.__BASE__.err
#PBS -l walltime=23:00:00
#PBS -l mem=30g
#####PBS -m ea
#PBS -l ncpus=12
#PBS -q omp
#PBS -r n


# Global variables
DATAOUTPUT="04_mapped/assembly"
DATAINPUT="03_trimmed/assembly"

# For transcriptome
GENOMEFOLDER="Symbiodinium_sp/pool"
GENOME="gmap_pool"

platform="Illumina"

#move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__

    # Align reads
    echo "Aligning $base"

    gsnap --gunzip -t 12 -A sam \
	--dir="$GENOMEFOLDER" -d "$GENOME" \
        -o "$DATAOUTPUT"/"$base".sam \
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
