

# STAR + RSEM (human/mouse) – Nextflow DSL2


A simple, reliable pipeline for aligning RNA‑seq reads with [STAR] and quantifying with [RSEM]. Works on  HPC with Docker/Singularity/Conda. Also a built in docker image can be used for deployment.

# Introduction:
STAR (Spliced Transcripts Alignment to a Reference) [1] is an ultrafast splice-aware aligner for RNA-seq that maps reads to genomes, detects canonical/non-canonical splice junctions, and supports two-pass mapping to improve novel junction discovery; it’s commonly used upstream of quantifiers like RSEM. 

RSEM (RNA-Seq by Expectation-Maximization) [2] estimates gene- and isoform-level expression from RNA-seq data, modeling fragment/length effects and outputting TPM/FPKM and expected counts. Works with reference transcriptomes (or de novo assemblies) and supports single/paired-end and stranded protocols

Using this pipeline, user can either create new indexes of genomes or use pre-existing ones. 


## Features
- ✅ Human or mouse presets; or fully custom references
- ✅ Optional **on‑the‑fly index** building from FASTA+GTF
- ✅ Slurm‑ready config; resuming supported (`-resume`)
- ✅ Paired‑end or single‑end reads
- ✅ Containers (Docker/Singularity) or Conda env

## Steps to make sure it runs smoothly
1. Make sure you have loaded singulariy. You can load singularity on HPC using:
     module load singularity
2.  Make sure you have installed nextflow. You can follow instructions on the nextflow webpage:https://www.nextflow.io/docs/latest/install.html
3.  Add the path where nextflow is to your bash (Follow instructions in Step 2).
    For bash :
    export PATH= "NEXTFLOW_INSTALLATION_PATH":$PATH
     

## Quick start
```bash
## For HPC (singularity needs to be loaded)

nextflow run main.nf -profile singularity \
  --samplesheet assets/samplesheet.example.csv \
  --species human \
  -resume

With Docker
nextflow run main.nf -profile docker \
  --samplesheet my_samples.csv \
  --species mouse
With Singularity (HPC)
nextflow run main.nf -profile slurm,singularity \
  --samplesheet my_samples.csv \
  --species human \
  -resume
With Conda
nextflow run main.nf -profile conda \
  --samplesheet my_samples.csv \
  --species human
Inputs

--samplesheet CSV with columns:

sample_id (unique)

fastq_1 (path to R1)

fastq_2 (optional path to R2, leave blank for SE)

read_group (optional; default added if missing)

--species: human or mouse. For other species, use custom references.

Reference options

Presets (edit in main.nf): hard‑coded cluster paths for GRCh38/GRCm39.

Custom prebuilt indices:

--star_index /path/to/STAR/index \
--rsem_ref /path/to/rsem/prefix   # NOTE: RSEM prefix string, not a folder

Build on the fly from FASTA+GTF:

--build_index --fasta /ref/genome.fa --gtf /ref/genes.gtf [--sjdbOverhang 100]
Outputs
results/
├── star/
│   ├── <sample>.Aligned.sortedByCoord.out.bam
│   ├── <sample>.Aligned.sortedByCoord.out.bam.bai
│   └── <sample>.Log.final.out
├── rsem/
│   ├── <sample>.genes.results
│   └── <sample>.isoforms.results
├── star_index/        # if build_index=true
└── rsem_ref/          # if build_index=true
Typical HPC (Slurm) usage
nextflow run main.nf -profile slurm,singularity \
  --samplesheet samplesheet.csv \
  --species human \
  --stranded reverse \
  -with-report report.html -with-trace -with-timeline timeline.html -resume
Notes & tips

Detects .gz reads and uses zcat automatically.

Set --stranded forward|reverse|none to match your library.

RSEM expects a prefix (e.g., /ref/rsem/GRCh38.gencode.v40).

For very deep or long reads, increase STAR memory/threads in conf/base.config.

Reproducibility

Prefer -profile docker or singularity for stable tool versions.

The provided envs/rna.yml pins STAR and RSEM for Conda use.

Troubleshooting

Missing genomeDir: Provide --star_index or use --build_index.

Cannot allocate memory: raise process.memory for STAR/RSEM in conf/base.config.




---


## How to adapt to your GitHub repo
1. Drop these files into your repo (or replace your existing `main.nf` & configs).
2. Edit the preset reference paths in `main.nf` under `reference_resolver()` to match your HPC.
3. Build the Docker image (optional) and push to GHCR:
   ```bash
   docker build -t ghcr.io/<youruser>/star-rsem:latest -f containers/Dockerfile .
   docker push ghcr.io/<youruser>/star-rsem:latest

Run with -profile slurm,singularity on HPC or -profile docker locally.

Nice‑to‑have future add‑ons (optional)

Add FastQC/MultiQC module for quick QC.

Add UMI handling (e.g., umi_tools) if needed.

Add strandedness auto‑detection (e.g., RSeQC infer_experiment.py).

If you share your GitHub link or upload your current main.nf/configs, I can transplant this structure and keep your commit history while minimizing breaking changes.
```

## Reference:
1. Dobin A, Davis CA, Schlesinger F, et al. STAR: ultrafast universal RNA-seq aligner. Bioinformatics 29(1):15–21 (2013). doi:10.1093/bioinformatics/bts635.
2. Li B, Dewey CN. RSEM: accurate transcript quantification from RNA-Seq data with or without a reference genome. BMC Bioinformatics 12, 323 (2011). doi:10.1186/1471-2105-12-323
