#!/usr/bin/sh
#export LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH
unset LD_PRELOAD
/usr/bin/singularity exec \
--bind /mnt/isilon/cccr_bfx/CCCR_Pipelines,  \
--pwd /mnt/isilon/cccr_bfx/CCCR_Pipelines/github/current/RNA-CCCR-Pipeline \
./container2/rna-cccr-pipeline_latest.sif \
nextflow run main_final.nf --max_memory 64G -profile standard \
-c ./nextflow.ALIGN.config \
--samplesheet ./assets/samplesheet.example.csv --read_group TEST --outdir ./docker_runs_test \
--genomeDir /mnt/isilon/cccr_bfx/CCCR_Pipelines/References/reference/Human/hg38_gencode_v39_may2024 \
--rsem_ref /mnt/isilon/cccr_bfx/CCCR_Pipelines/References/reference/Human/rsem_hg38_v39/rsem_hg38_v39  \
-resume
