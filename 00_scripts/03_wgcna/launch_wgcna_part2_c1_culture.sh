#!/bin/bash
#PBS -l walltime=20:00:00
#PBS -l mem=100gb
#PBS -N "wgcna_culture"
#PBS -o "log.wgcna_part2_c1_culture.out"
#PBS -l ncpus=1
#PBS -r n

cd $PBS_O_WORKDIR

Rscript --vanilla wgcna_part2_c1_culture.R
