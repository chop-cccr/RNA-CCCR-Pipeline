#!/bin/sh
export PATH="/mnt/isilon/cccr_bfx/Pipelines/Independent/":$PATH
module load Java/17.0.6
module load singularity
module load STAR
module load SAMtools
module load RSEM
conda activate /home/mishrap/miniconda3/envs/fastqc
module load Java/17.0.6

