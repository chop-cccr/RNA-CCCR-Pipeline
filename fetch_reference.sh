#!/usr/bin/env bash
# Copy the entire reference directory tree into a destination.
# - Defaults SRC to /mnt/isilon/reference if present (overridable via .env.local or env var)
# - MODE: copy (default) or hardlink
# - DRY:  true to preview actions
set -euo pipefail

# Load private overrides if present
[[ -f .env.local ]] && source .env.local || true

# Config (env overridable)
SRC="${SRC_DIR:-}"
[[ -z "${SRC}" && -d /mnt/isilon/cccr_bfx/CCCR_Pipelines/github/RNA-CCCR-Pipeline/reference/ ]] && SRC="/mnt/isilon/cccr_bfx/CCCR_Pipelines/github/RNA-CCCR-Pipeline/reference/"

DST="${1:-}"                   # required: destination directory path
MODE="${MODE:-copy}"           # copy | hardlink
DRY="${DRY:-false}"            # true | false

usage() {
  cat <<EOF
Usage: $0 <DEST_DIR>

Environment (optional):
  SRC_DIR=/abs/path/to/reference   (default: /mnt/isilon/cccr_bfx/CCCR_Pipelines/RNA-Seq_Pipeline_HPC/reference/ if it exists)
  MODE=copy|hardlink               (default: copy; hardlink requires same filesystem)
  DRY=true                         (preview only)

Behavior:
  - Copies the *contents* of SRC into DEST (i.e., SRC/* -> DEST/).
  - Preserves permissions, times, symlinks (cp -a).
  - Hardlink mode tries cp -al, falls back to cp -a if linking fails.
EOF
  exit 1
}

[[ -n "${DST}" ]] || usage
[[ -n "${SRC}" && -d "${SRC}" ]] || { echo "ERROR: SRC_DIR not set or not found: '${SRC}'" >&2; exit 2; }

mkdir -p "${DST}"

echo "Source : ${SRC}"
echo "Dest   : ${DST}"
echo "Mode   : ${MODE}"
echo "Dry    : ${DRY}"
echo

if [[ "${DRY}" == "true" ]]; then
  echo "[DRY] Would copy entire directory tree:"
  echo "      ${MODE} '${SRC}/' -> '${DST}/'"
  exit 0
fi

# Copy the entire directory contents
case "${MODE}" in
  hardlink)
    # Attempt hardlinking; if cross-filesystem or any failure, fall back to full copy
    if cp -al "${SRC}/." "${DST}/" 2>/dev/null; then
      echo "Hardlinked tree successfully."
    else
      echo "Hardlinking failed (likely cross-filesystem). Falling back to real copy..."
      cp -a "${SRC}/." "${DST}/"
      echo "Copied tree successfully."
    fi
    ;;
  copy)
    cp -a "${SRC}/." "${DST}/"
    echo "Copied tree successfully."
    ;;
  *)
    echo "ERROR: Unknown MODE '${MODE}'. Use 'copy' or 'hardlink'." >&2
    exit 3
    ;;
esac

