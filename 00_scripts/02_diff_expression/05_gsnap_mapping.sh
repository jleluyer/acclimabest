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
#DATAOUTPUT="/scratch/home1/jleluyer/acclimabest/04_mapped/diff_expr"
#DATAINPUT="/scratch/home1/jleluyer/acclimabest/03_trimmed/diff_expr"

DATAOUTPUT="04_mapped/corals"
DATAINPUT="03_trimmed/corals"

#For combined
GENOMEFOLDER_combined="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/"
GENOME_combined="combined.transcriptome"

# For transcriptome
<<<<<<< HEAD
GENOMEFOLDER_symbiont="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/"
GENOME_symbiont="symbiont.transcriptome"

# For genome
GENOMEFOLDER_host="/home1/datawork/jleluyer/01_projects/acclimabest/acclimabest/08_trimmed_assembly/"
GENOME_host="host.transcriptome"
=======
GENOMEFOLDER_symbiont="gmap_symbiodiniumspC1"
GENOME_symbiont="gmap_symbiodiniumspC1"

# For genome
GENOMEFOLDER_host="P_margaritifera"
GENOME_host="indexed_genome"
>>>>>>> 2cb3adf5747abb1060eb5ca4c7d30ac5063238df
platform="Illumina"

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



exit
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
	"$DATAINPUT"/"$base"_R1.paired.fastq.gz "$DATAINPUT"/"$base"_R2.paired.fastq.gz
    
# Create bam file
    echo "Creating bam for $base"
    samtools view -Sb -q 5 -F 4 -F 256 \
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
        "$DATAINPUT"/"$base"_R1.paired.fastq.gz "$DATAINPUT"/"$base"_R2.paired.fastq.gz

# Create bam file
    echo "Creating bam for $base"
    samtools view -Sb -q 5 -F 4 -F 256 \
        "$DATAOUTPUT"/"$base".host.sam >"$DATAOUTPUT"/"$base".host.bam

     echo "Creating sorted bam for $base"
        samtools sort -n "$DATAOUTPUT"/"$base".host.bam -o "$DATAOUTPUT"/"$base".host.sorted.bam
        samtools index "$DATAOUTPUT"/"$base".host.sorted.bam
