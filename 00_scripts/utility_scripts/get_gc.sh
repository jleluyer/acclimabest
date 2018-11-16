#!/bin/bash

. /appli/bioinfo/emboss/latest/env.sh

infoseq -auto -only -name -pgc  08_trimmed_assembly/symbiont.transcriptome.fa >symbiont_gc.txt

infoseq -auto -only -name -pgc  08_trimmed_assembly/host.transcriptome.fa >host_gc.txt

