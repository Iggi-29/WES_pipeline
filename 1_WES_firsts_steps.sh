#!/bin/bash
## WES firsts steps. After the preparation of
## genome files, we will trim low quality reads and
## then we will align them to their reference genome.

### Define global variables
CURRENT_DIRECTORY=$(pwd)
raw_data="${CURRENT_DIRECTORY}/raw_data/"
alignments="${CURRENT_DIRECTORY}/alignment/"
ref_genome="${CURRENT_DIRECTORY}/genome_data/chr7.fa"

### Quality control
# echo "###############################" 
# echo "#####  fastQC first run  #####"
# echo "###############################"

cd $raw_data
# mkdir "z_data_quality"

# for  fastq_file in $(ls *.fastq.gz);do
#     fastqc $fastq_file -o "${raw_data}z_data_quality"
# done


################################## ADD TRIMMING !!

### Alignment
# echo "###############################" 
# echo "#####  bwa mem alignment  #####"
# echo "###############################"

# for fastq_paired in $(ls *.fastq.gz | sed 's/_1\.fastq\.gz$//');do
#     fastq_pair_name=$(basename "${fastq_paired}" | sed 's/_1\.fastq\.gz$//')
#     echo "Aligning ${fastq_pair_name}"
#     bwa mem -T 7 \
#     -R "@RG\tID:${fastq_pair_name}\tPL:ILLUMINA\tSM:${fastq_pair_name}" \
#     "${ref_genome}" \
#     "${raw_data}${fastq_pair_name}_1.fastq.gz" "${raw_data}${fastq_pair_name}_2.fastq.gz" > "${alignments}${fastq_pair_name}_paired.sam"
#     echo "Aligning ${fastq_pair_name} done"
# done

### Samtools sorting
echo "###############################" 
echo "#####  Samfiles sorting  #####"
echo "###############################"

cd $alignments
for sam_file in $(ls *_paired.sam); do
    sam_file_name=$(basename $sam_file | sed 's/_paired.sam//')
    echo "Samtools work on ${sam_file_name}"
    samtools view -bS "${alignments}${sam_file_name}_paired.sam" | samtools sort -O BAM -o "${alignments}${sam_file_name}_sorted.bam"
    samtools view -h "${alignments}${sam_file_name}_sorted.bam" > "${alignments}${sam_file_name}_sorted.sam"
    echo "Samtools work on ${sam_file_name} done"
done