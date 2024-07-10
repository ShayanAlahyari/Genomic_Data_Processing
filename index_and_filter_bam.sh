#!/bin/bash

#$ -N GATK_snp_calling_steps0_1
#$ -S /bin/bash
#$ -pe smp 32 

# Command-line Arguments
MINICONDA_PATH="$1"
WORK_DIR="$2"

# Exit if any required arguments are missing
if [ -z "$MINICONDA_PATH" ] || [ -z "$WORK_DIR" ]; then
  echo "Error: Missing arguments."
  echo "Usage: $0 <miniconda_path> <work_dir>"
  exit 1
fi

# Extend PATH to include Miniconda3 binaries
export PATH="${MINICONDA_PATH}/bin:$PATH"

# Set working directory and exit if it does not exist
cd "${WORK_DIR}" || exit 1

# Index BAM files using parallel samtools
echo "Starting BAM indexing..."
find . -type f -name "*.bam" -print0 | parallel -j 16 -0 "samtools index -@4 -c {}"

# Filter BAM files for paired reads with quality > 1
echo "Starting paired-end filtering..."
find . -type f -name "*.bam" -print0 | parallel -j 16 -0 "samtools view -@4 -f 2 -q 1 {} -o {.}_paired.bam"

echo "Steps completed."
