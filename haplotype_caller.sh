#!/bin/bash

#$ -N GATK_HaplotypeCaller_Original
#$ -S /bin/bash
#$ -pe smp 32

# Command-line Arguments
CONDA_PATH="$1"
GATK_PATH="$2"
REFERENCE_GENOME="$3"
ORIGINAL_BAM="$4"
ORIGINAL_OUTPUT_DIR="$5"

# Exit if any required arguments are missing
if [ -z "$CONDA_PATH" ] || [ -z "$GATK_PATH" ] || [ -z "$REFERENCE_GENOME" ] || [ -z "$ORIGINAL_BAM" ] || [ -z "$ORIGINAL_OUTPUT_DIR" ]; then
  echo "Error: Missing arguments."
  echo "Usage: $0 <conda_path> <gatk_path> <reference_genome> <original_bam> <original_output_dir>"
  exit 1
fi

export PATH="${CONDA_PATH}:$PATH"
export JAVA_OPTS="-Xmx32G"
export TMP_DIR="/path/to/temp_directory"

# Create output directory if it does not exist
mkdir -p "$ORIGINAL_OUTPUT_DIR"

# Run HaplotypeCaller on the original BAM file
${GATK_PATH} HaplotypeCaller -R ${REFERENCE_GENOME} \
                            -I ${ORIGINAL_BAM} \
                            -O ${ORIGINAL_OUTPUT_DIR}/merged_output_paired_md_RG_recal_output.g.vcf \
                            -ERC GVCF \
                            --native-pair-hmm-threads 8

echo "HaplotypeCaller finished for the original BAM file."
