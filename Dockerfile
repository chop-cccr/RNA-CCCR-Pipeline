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

# ---------- Non-root runtime user ----------
ARG UID=1000
ARG GID=1000
ARG USERNAME=nfuser

RUN set -eux; \
    # Create group and user if they don't already exist
    getent group ${GID} || groupadd -g ${GID} ${USERNAME}; \
    id -u ${UID} >/dev/null 2>&1 || useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME}; \
    # Workspace + tools dir in user's home
    mkdir -p /workspace /home/${USERNAME}/tools; \
    # Symlink main tools into /home/${USERNAME}/tools
    ln -s /opt/conda/bin/STAR          /home/${USERNAME}/tools/STAR; \
    ln -s /opt/conda/bin/RSEM*         /home/${USERNAME}/tools/ || true; \
    ln -s /opt/conda/bin/fastqc        /home/${USERNAME}/tools/fastqc; \
    ln -s /opt/conda/bin/samtools      /home/${USERNAME}/tools/samtools; \
    ln -s /usr/local/bin/nextflow      /home/${USERNAME}/tools/nextflow; \
    # Permissions
    chown -R ${USERNAME}:${USERNAME} /workspace /home/${USERNAME}; \
    chmod 1777 /tmp

# ---------- Runtime environment ----------
ENV HOME=/home/${USERNAME} \
    XDG_CACHE_HOME=/tmp \
    TMPDIR=/tmp \
    UMASK=0002

# Put user's tools first on PATH (they point to /opt/conda/bin + nextflow)
ENV PATH=/home/${USERNAME}/tools:$PATH

USER ${USERNAME}
WORKDIR /workspace
SHELL ["/bin/bash","-lc"]
CMD ["bash"]

