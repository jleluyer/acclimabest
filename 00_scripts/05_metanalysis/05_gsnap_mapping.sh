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

# Global variables for genome
DATAOUTPUT="/scratch/04_mapped/metanalysis"
DATAINPUT="/scratch/03_trimmed/metanalysis"


# For transcriptome
GENOMEFOLDER_symbiont="08_trimmed_assembly/"
GENOME_symbiont="symbiont.transcriptome"

GENOMEFOLDER_c1="00_ressources/genomes/S_cladeC/"
GENOME_c1_index="genome_symbC"

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
	--dir="$GENOMEFOLDER_c1" -d "$GENOME_c1_index" \
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

