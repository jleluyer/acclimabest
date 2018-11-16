#!/bin/bash
#PBS -N gsnap.trans.__BASE__
#PBS -o gsnap.trans.__BASE__.err
#PBS -l walltime=24:00:00
#PBS -l mem=50g
#####PBS -m ea
#PBS -l ncpus=12
#PBS -q omp
#PBS -r n

# import samtools


# Global variables
DATAOUTPUT="04_mapped/corals"
DATAINPUT="03_trimmed/corals"

#For combined
GENOMEFOLDER_combined="08_trimmed_assembly/"
GENOME_combined="combined.transcriptome"

#for genome C1
GENOMEFOLDER_symbiont="gmap_symbiodiniumspC1"
GENOME_symbiont="gmap_symbiodiniumspC1"

#move to present working dir
cd $PBS_O_WORKDIR

base=__BASE__


####################################################################
################## combined ########################################
####################################################################
    # Align reads
#    echo "Aligning $base"

    gsnap --gunzip -t 12 -A sam \
        --dir="$GENOMEFOLDER_combined" -d "$GENOME_combined" \
        -o "$DATAOUTPUT"/"$base".combined.sam \
        --max-mismatches=5 --novelsplicing=1 \
        --read-group-id="$base" \
         --read-group-platform="$platform" \
        "$DATAINPUT"/"$base"_R1.paired.fastq.gz "$DATAINPUT"/"$base"_R2.paired.fastq.gz

# Create bam file
    echo "Creating bam for $base"
    samtools view -Sb -q 5 -F 4 -F 256 \
        "$DATAOUTPUT"/"$base".combined.sam >"$DATAOUTPUT"/"$base".combined.bam

     echo "Creating sorted bam for $base"
        samtools sort -n "$DATAOUTPUT"/"$base".combined.bam -o "$DATAOUTPUT"/"$base".combined.sorted.bam
        samtools index "$DATAOUTPUT"/"$base".combined.sorted.bam

