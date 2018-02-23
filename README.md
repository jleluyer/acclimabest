# Acclimabest

**WARNING**

The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

## Documentation

### 1. Trancriptome assembly

#### 1.1 Raw data trimming

```
00_scripts/datarmor/01_transcriptome_assembly/01_trimmomatic_jobs_pe.sh
```
*Make sure that you are in the root of the git repository*

#### 1.2 Prepare reference
 
```
qsub 00_scripts/01_transcriptome_assembly/02_gmap_index.sh 
```

#### 1.3 Filtering datasets assembly

This step is meant to tease apart host from symbionts transcripts (*i.e* Corals, Giant clams,..)

```
00_scripts/datarmor_jobs/01_transcriptome_assembly/03_gmap_mapping_jobs.sh

00_scripts/datarmor_jobs/01_transcriptome_assembly/04_clean_dataset_jobs.sh
```

#### 1.4 Assemble the transcriptome

```
qsub 00_scripts/datarmor_jobs/05_merge_input.sh

qsub 00_scripts/datarmor_jobs/06_assemble_trinity.sh
```

#### 1.5 Assembly statistics

```
qsub 00_scripts/datarmor_jobs/07_assembly_stats
```

#### 1.6 Assembly filtering

```
```

### 2. Differential expression analysis

#### 2.1 Raw data trimming

```
00_scripts/datarmor/02_diff_expression/01_trimmomatic_jobs_pe.sh
```
*Make sure that you are in the root of the git repository*

#### 2.2 Prepare reference

```
qsub 00_scripts/02_diff_expression/02_gmap_index.sh
```

#### 2.3 Filtering datasets assembly

This step is meant to tease apart host from symbionts transcripts (*i.e* Corals, Giant clams,..)

```
00_scripts/datarmor_jobs/02_diff_expression/03_gmap_mapping_jobs.sh

00_scripts/datarmor_jobs/02_diff_expression/04_clean_dataset_jobs.sh
```

#### 2.4 Mapping

```
00_scripts/datarmor_jobs/02_diff_expression/05_gsnap_mapping_jobs.sh
```

#### 2.5 Counting gene expression

```
00_scripts/datarmor_jobs/02_diff_expression/06_htseq_count.sh
```

#### 2.6 Differential expression testing

```
```

## Prerequisities

[BBmap](https://sourceforge.net/projects/bbmap/)

[GMAP/GSNAP](http://research-pub.gene.com/gmap/)

[samtools](http://www.htslib.org/doc/samtools.html)

[seqtk](https://github.com/lh3/seqtk)

[sra-tools](https://github.com/ncbi/sra-tools)

[Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)

[Trinity](https://github.com/trinityrnaseq/trinityrnaseq/wiki)

[UniVec](https://www.ncbi.nlm.nih.gov/tools/vecscreen/univec/)

## Flow chart

Typical Acclimabest workflow. 

*in progress*

![](01_info_files.png)

## Contributors

**Alves Monteiro Kisalu Homère** e-mail: homere.alves-monteiro-kisalu@edu.mnhn.fr

**Brahmi Chloé** e-mail: chloe.brahmi@upf.pf

**Lapeyre Bruno** e-mail: bruno.lapeyre@criobe.pf

**Le Luyer Jérémy** e-mail: jeremy.le.luyer@ifremer.fr

