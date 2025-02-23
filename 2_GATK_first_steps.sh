#!/bin/bash
## WES firsts steps. After the preparation of
## genome files, we will trim low quality reads and
## then we will align them to their reference genome.

### Define global variables
CURRENT_DIRECTORY=$(pwd)
raw_data="${CURRENT_DIRECTORY}/raw_data/"
alignments="${CURRENT_DIRECTORY}/alignment/"
ref_genome="${CURRENT_DIRECTORY}/genome_data/chr7.fa"
known_sites="${CURRENT_DIRECTORY}/genome_data/Homo_sapiens_assembly38.dbsnp138.vcf"
results="${CURRENT_DIRECTORY}/results/"

### GATK MarkDuplicates
echo "###############################" 
echo "####  GATK MarkDuplicates  ####"
echo "###############################"

cd $alignments
for sam_sorted_file in $(ls *_sorted.sam); do
    sam_file_name=$(basename $sam_sorted_file | sed 's/_sorted.sam//')
    echo "Marking of duplicates for ${sam_file_name}"
    singularity exec -e -B "/home/ignasi/Desktop/WES_pipeline" "${CURRENT_DIRECTORY}/gatk_4.6.1.0.sif" gatk MarkDuplicatesSpark \
    -I "${alignments}${sam_file_name}_sorted.sam" \
    -O "${alignments}${sam_file_name}_dedup.bam" 
    echo "Marking of duplicates for ${sam_file_name} done"
done

### GATK BaseRecallibration
echo "###############################" 
echo "###  GATK BaseRecalibrator  ###"
echo "###############################"

for bam_dedup_file in $(ls *_dedup.bam); do
    bam_dedup_name=$(basename $bam_dedup_file | sed 's/_dedup.bam//')
    echo "Generating the recallibration model for ${bam_dedup_name}"
    singularity exec -e -B "/home/ignasi/Desktop/WES_pipeline" "${CURRENT_DIRECTORY}/gatk_4.6.1.0.sif" gatk BaseRecalibrator \
    -I "${alignments}/${bam_dedup_name}_dedup.bam" \
    -R "${ref_genome}" \
    --known-sites "${known_sites}" \
    -O "${results}/${bam_dedup_name}_base_recal.table"
    echo "Generating the recallibration model for0 ${bam_dedup_name} done"
done

