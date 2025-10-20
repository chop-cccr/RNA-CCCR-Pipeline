nextflow.enable.dsl=2

/*
 * This module provides a named subworkflow:
 *   RSEM_POSTREPORT_MIN( quant_ch )
 * where quant_ch: tuples (sid, genes.results, isoforms.results)
 * Emits:
 *   report_pdf -> path to rsem_report.pdf
 *   summaries  -> tuples (sid, <sid>.rsem.summary.tsv)
 */

process RSEM_SUMMARY_MIN {
  tag { sid }
  label 'r_report'
  publishDir "${params.outdir ?: 'results'}/report/summaries", mode: 'copy', overwrite: true

  input:
    tuple val(sid), path(genes), path(isoforms)

  output:
    tuple val(sid), path("${sid}.rsem.summary.tsv")

  shell:
  '''
  set -euo pipefail

  # inline R summarizer
 cat > summarize.R <<'RSCRIPT'

suppressPackageStartupMessages({
  library(readr); library(dplyr); library(argparse)
})
p <- argparse::ArgumentParser()
p$add_argument("--sample", required=TRUE)
p$add_argument("--genes",  required=TRUE)
p$add_argument("--out",    required=TRUE)
a <- p$parse_args()

args <- commandArgs(trailingOnly = TRUE)
arg_val <- function(flag, default = NA) {
  i <- match(flag, args)
  if (!is.na(i) && i < length(args)) args[i + 1] else default
}
sample_id <- arg_val("--sample")
genes_fp  <- arg_val("--genes")
out_fp    <- arg_val("--out")

if (is.na(sample_id) || is.na(genes_fp) || is.na(out_fp)) {
  stop("Usage: Rscript rsem_summarize_simple.R --sample <ID> --genes <genes.results> --out <output.tsv>")
}

# -------- read the RSEM genes.results (TSV) --------
genes <- read.table(
  genes_fp,
  header=TRUE, 
  sep = "\t",
  quote = "",
  comment.char = "",
  check.names = FALSE,
  stringsAsFactors = FALSE,
  fill = TRUE
)

# normalize header names; fill blanks
nm <- tolower(gsub("[^a-z0-9]+", "_", names(genes)))
blank <- which(nchar(nm) == 0)
if (length(blank)) nm[blank] <- paste0("col", blank)
names(genes) <- nm

# helper to pick a column by name (case-normalized) with index fallback
pick_col <- function(df, name_candidates, fallback_idx = NA_integer_) {
  nn <- names(df)
  hit <- which(nn %in% tolower(name_candidates))
  if (length(hit) >= 1) {
    nn[hit[1]]
  } else if (!is.na(fallback_idx) && fallback_idx <= ncol(df)) {
    nn[fallback_idx]
  } else {
    NA_character_
  }
}
  
