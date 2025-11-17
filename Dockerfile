FROM mambaorg/micromamba:1.5.8

LABEL maintainer="Pam / CHOP CCCR"
LABEL description="RNA-Seq pipeline tools: STAR, RSEM, FastQC, samtools, Java, Nextflow"

ENV DEBIAN_FRONTEND=noninteractive \
    MAMBA_NO_BANNER=1

# Basic OS deps
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      bash coreutils findutils gawk tar unzip bzip2 pigz procps \
      ca-certificates curl wget git; \
    rm -rf /var/lib/apt/lists/*

# Install bio tools into /opt/conda via micromamba
RUN set -eux; \
    micromamba install -y -n base -c conda-forge -c bioconda \
      openjdk=17 \
      fastqc=0.12.1 \
      star=2.7.11b \
      rsem=1.3.3 \
      samtools=1.20; \
    micromamba clean -a -y

# Install Nextflow
RUN set -eux; \
    curl -fsSL https://get.nextflow.io -o /usr/local/bin/nextflow; \
    chmod +x /usr/local/bin/nextflow

# Symlink key tools into /usr/local/bin (like the cellranger example)
RUN set -eux; \
    ln -s /opt/conda/bin/STAR                     /usr/local/bin/STAR; \
    ln -s /opt/conda/bin/RSE

