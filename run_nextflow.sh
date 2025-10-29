#!/bin/sh
#If reference folder was downloaded in the same directory 
#as nextflow. If not, change the --genomeDir and --rsem_ref
    nextflow run main_final.nf \
    -c  ./nextflow.ALIGN.config \
    --samplesheet ./assets/samplesheet.example.csv \
    --read_group TEST  \
    --outdir /mnt/isilon/cccr_bfx/CCCR_Pipelines/RNA-Seq_Pipeline_HPC/example/TEST_HPC_runs  \
    --genomeDir ./reference/Mouse/Reference/mm10_gencode/mm10STAR/  \
    --rsem_ref ./reference/Mouse/rsem_index/rsem_mm10  \
    --threads 10 -profile singularity 

