# Tools via Bioconda (FastQC/STAR/RSEM/samtools) + Nextflow + Java 17
FROM mambaorg/micromamba:1.5.8

# ---------- Build-time setup ----------
USER root
ENV DEBIAN_FRONTEND=noninteractive \
    MAMBA_NO_BANNER=1

# OS basics + certificates
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      bash coreutils findutils gawk tar unzip bzip2 pigz procps \
      ca-certificates curl wget git \
    ; \
    rm -rf /var/lib/apt/lists/*

# Bio tools (pin versions to avoid solver drift)
# If solver stalls, the pins below help a lot.
RUN set -eux; \
    micromamba install -y -n base -c conda-forge -c bioconda \
      openjdk=17 \
      fastqc=0.12.1 \
      star=2.7.11b \
      rsem=1.3.3 \
      samtools=1.20 \
    ; \
    micromamba clean -a -y

# Install Nextflow (uses Java 17 above)
RUN set -eux; \
    curl -fsSL https://get.nextflow.io -o /usr/local/bin/nextflow; \
    chmod +x /usr/local/bin/nextflow

# Ensure binaries on PATH
ENV PATH=/opt/conda/bin:$PATH

# ---------- Non-root runtime user ----------
ARG UID=1000
ARG GID=1000
ARG USERNAME=nfuser

# Create group only if not exists; same for user (avoids errors on some bases)
RUN set -eux; \
    getent group ${GID} || groupadd -g ${GID} ${USERNAME}; \
    id -u ${UID} >/dev/null 2>&1 || useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME}; \
    mkdir -p /workspace; \
    chown -R ${USERNAME}:${USERNAME} /workspace /home/${USERNAME}; \
    chmod 1777 /tmp

# Writable cache/temp to avoid permission problems
ENV HOME=/home/${USERNAME} \
    XDG_CACHE_HOME=/tmp \
    TMPDIR=/tmp \
    UMASK=0002

USER ${USERNAME}
WORKDIR /workspace
SHELL ["/bin/bash","-lc"]
CMD ["bash"]

