# Dockerfile
FROM mambaorg/micromamba:1.5.8
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash coreutils git curl ca-certificates procps pigz unzip bzip2 tar \
    && rm -rf /var/lib/apt/lists/*
# If you have environment.yml, this installs it:
COPY environment.yml /tmp/environment.yml
RUN micromamba install -y -n base -f /tmp/environment.yml && \
    micromamba install -y -n base openjdk=11 && \
    micromamba clean -a -y
ENV PATH=/opt/conda/bin:$PATH
RUN useradd -m -u 1000 nfuser
USER nfuser
WORKDIR /workspace
SHELL ["/bin/bash", "-lc"]
CMD ["bash"]

