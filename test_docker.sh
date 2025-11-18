#singularity exec -e docker://ghcr.io/pamelanmrc/rna-seq-nextflow-docker:latest \
#  bash -lc 'env | head; which STAR; STAR --version; which fastqc; which samtools'
singularity build rna-cccr-pipeline_v0.4.0.sif \
docker://ghcr.io/pamelanmrc/rna-seq-nextflow-docker:latest 
