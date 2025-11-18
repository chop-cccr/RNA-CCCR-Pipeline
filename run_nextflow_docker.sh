 nextflow run main_final.nf -profile slurm,singularity   --container "docker://ghcr.io/chop-cccr/rna-cccr-pipeline:latest" -c  ./nextflow.ALIGN.config   --samplesheet ./assets/samplesheet.example.csv --read_group TEST   --outdir ../TEST_HPC_runs \
  --genomeDir /mnt/isilon/thomas-tikhonenko_lab/user/mishrap/Reference/hg38_gencode_v39_may2024 \
  --rsem_ref /mnt/isilon/cccr_bfx/CCCR_Pipelines/RNA-Seq_Pipeline_HPC/reference/Mouse/rsem_index/rsem_mm10

