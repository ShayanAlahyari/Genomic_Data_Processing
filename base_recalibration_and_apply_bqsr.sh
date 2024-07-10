#!/bin/bash

#$ -N GATK_snp_calling_steps4_5
#$ -S /bin/bash
#$ -pe smp 32

# Command-line Arguments
MINICONDA_PATH="$1"
WORK_DIR="$2"
GATK_PATH="$3"
SCRIPTS_DIR="$4"
REFERENCE_GENOME="$5"
KNOWN_SITES="$6"
TMP_DIR="$7"

# Exit if any required arguments are missing
if [ -z "$MINICONDA_PATH" ] || [ -z "$WORK_DIR" ] || [ -z "$GATK_PATH" ] || [ -z "$SCRIPTS_DIR" ] || [ -z "$REFERENCE_GENOME" ] || [ -z "$KNOWN_SITES" ] || [ -z "$TMP_DIR" ]; then
  echo "Error: Missing arguments."
  echo "Usage: $0 <miniconda_path> <work_dir> <gatk_path> <scripts_dir> <reference_genome> <known_sites> <tmp_dir>"
  exit 1
fi

# Extend PATH to include Miniconda3 binaries
export PATH="${MINICONDA_PATH}:$PATH"

# Set working directory and exit if it does not exist
cd "${WORK_DIR}" || exit 1

# BaseRecalibrator
echo "Starting BaseRecalibrator..."
find . -name "*_md_RG.bam" -print0 | parallel -j 32 -0 "bash ${SCRIPTS_DIR}/BaseRecalibrator.sh {} ${GATK_PATH} ${REFERENCE_GENOME} ${KNOWN_SITES} ${TMP_DIR}"

# Apply BQSR
echo "Applying BQSR..."
find . -name "*_md_RG.bam" -print0 | parallel -j 32 -0 "bash ${SCRIPTS_DIR}/ApplyBQSR.sh {} ${GATK_PATH} ${REFERENCE_GENOME} ${TMP_DIR} {/.}_recal.table"
echo "Steps completed."
