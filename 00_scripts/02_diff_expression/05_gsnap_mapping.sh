#!/bin/bash
#PBS -N gsnap.trans.__BASE__
#PBS -o gsnap.trans.__BASE__.err
#PBS -l walltime=24:00:00
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
GENOMEFOLDER_symbiont="/home1/datawork/jleluyer/00_ressources/transcriptomes/Symbiodinium_sp/clade_C1/gmap_symbiodiniumspC1"
GENOME_symbiont="gmap_symbiodiniumspC1"

# For genome
GENOMEFOLDER_host="/home1/datawork/jleluyer/00_ressources/genomes/P_margaritifera"
GENOME_host="indexed_genome"
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
	"$DATAINPUT"/"$base".symbiont.fastq.gz
    
# Create bam file
    echo "Creating bam for $base"
    samtools view -Sb -q 5 -F 4 -F 256 \
        "$DATAOUTPUT"/"$base".symbiont.sam >"$DATAOUTPUT"/"$base".symbiont.bam
	
     echo "Creating sorted bam for $base"
	samtools sort -n "$DATAOUTPUT"/"$base".symbiont.bam -o "$DATAOUTPUT"/"$base".symbiont.sorted.bam
    	samtools index "$DATAOUTPUT"/"$base".symbiont.sorted.bam

    # Clean up
    echo "Removing "$TMP"/"$base".sam"
    echo "Removing "$TMP"/"$base".bam"

   	rm "$DATAOUTPUT"/"$base".symbiont.sam
    	rm "$DATAOUTPUT"/"$base".symbiont.bam


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
        "$DATAINPUT"/"$base".host.fastq.gz

# Create bam file
    echo "Creating bam for $base"
    samtools view -Sb -q 5 -F 4 -F 256 \
        "$DATAOUTPUT"/"$base".host.sam >"$DATAOUTPUT"/"$base".host.bam

     echo "Creating sorted bam for $base"
        samtools sort -n "$DATAOUTPUT"/"$base".host.bam -o "$DATAOUTPUT"/"$base".host.sorted.bam
        samtools index "$DATAOUTPUT"/"$base".host.sorted.bam

    # Clean up
    echo "Removing "$TMP"/"$base".sam"
    echo "Removing "$TMP"/"$base".bam"

        rm "$DATAOUTPUT"/"$base".host.sam
        rm "$DATAOUTPUT"/"$base".host.bam

