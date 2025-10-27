#!/bin/sh
/mnt/isilon/cccr_bfx/CCCR_Pipelines/archive/Independent/nextflow run main_final.nf \
    -c  /mnt/isilon/cccr_bfx/CCCR_Pipelines/RNA-Seq_Pipeline_HPC/nextflow.ALIGN.config \
    --samplesheet /mnt/isilon/cccr_bfx/CCCR_Pipelines/RNA-Seq_Pipeline_HPC/assets/samplesheet.example.csv \
    --read_group TEST  \
    --outdir /mnt/isilon/cccr_bfx/CCCR_Pipelines/RNA-Seq_Pipeline_HPC/example/TEST_HPC_runs  \
    --genomeDir /mnt/isilon/cccr_bfx/CCCR_Pipelines/RNA-Seq_Pipeline_HPC/reference/Mouse/Reference/mm10_gencode/mm10STAR/  \
    --rsem_ref /mnt/isilon/cccr_bfx/CCCR_Pipelines/RNA-Seq_Pipeline_HPC/reference/Mouse/rsem_index/rsem_mm10  \
    --threads 10 -profile singularity 

