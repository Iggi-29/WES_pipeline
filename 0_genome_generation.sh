#!/bin/bash
### WES pipeline script, here, we will set all the required directories and 
### also download and prepare all the necessary files

### Save some important variables 
# genome_raw
CURRENT_DIR=$(pwd)
echo "${CURRENT_DIR}"
genome="${CURRENT_DIR}_genome_data/chr7.fa"

### Genome indexing
echo "################################"
echo "### Genome files preparation ###"
echo "################################"

echo "BWA genome indexing"
bwa  index $genome
echo "BWA genome indexing done"

echo ".fai genome file generation"
samtools faidx chr7.fa
echo ".fai genome file generation done"