singularity exec docker://ghcr.io/chop-cccr/rna-cccr-pipeline:v0.3.0 \
  bash -lc 'which STAR; STAR --version; which fastqc; which samtools'

