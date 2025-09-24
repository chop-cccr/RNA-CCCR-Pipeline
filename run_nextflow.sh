#!/bin/sh
/mnt/isilon/cccr_bfx/Pipelines/Independent/nextflow run main_final.nf -c  /mnt/isilon/cccr_bfx/Pipelines/Independent/current/RNA-Seq_Pipeline/nextflow.ALIGN.config  --samplesheet /mnt/isilon/cccr_bfx/Pipelines/Independent/current/RNA-Seq_Pipeline/assets/samplesheet.example.csv --read_group TEST  --outdir /mnt/isilon/cccr_bfx/Pipelines/Independent/current/RNA-Seq_Pipeline/HELLO_KITTY --genomeDir /mnt/isilon/dbhi_bfx/mishrap/Adam/Kevin/Reference/mm10_gencode/mm10STAR/  --species mouse --rsem_ref /mnt/isilon/dbhi_bfx/mishrap/Kris/Anna_Mouse_Geneviz/Reference//rsem_index/rsem_mm10  --threads 10 -profile singularity -resume


