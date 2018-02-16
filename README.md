# Acclimabest

**WARNING**

The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.

## Documentation

### Trancriptome assembly

#### 1. Raw data trimming

```
~> 00_scripts/datarmor/01_trimmomatic_jobs_pe.sh
```
*Make sure that you are in the root of the git repository*

#### 2. Prepare reference
 
```
qsub 00_scripts/02_gmap_index.sh 
```

#### 3 Filtering datasets assembly

```
00_scripts/datarmor_jobs/03_gmap_mapping_jobs.sh

00_scripts/datarmor_jobs/04_clean_dataset_jobs.sh
```

#### 4. Assemble the transcriptome

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
