#!/bin/bash

#$ -N GATK_snp_calling_steps2_3
#$ -S /bin/bash
#$ -pe smp 32  

# Command-line Arguments
MINICONDA_PATH="$1"
WORK_DIR="$2"
TMP_DIR="$3"
GATK_PATH="$4"
SCRIPTS_DIR="$5"

# Exit if any required arguments are missing
if [ -z "$MINICONDA_PATH" ] || [ -z "$WORK_DIR" ] || [ -z "$TMP_DIR" ] || [ -z "$GATK_PATH" ] || [ -z "$SCRIPTS_DIR" ]; then
  echo "Error: Missing arguments."
  echo "Usage: $0 <miniconda_path> <work_dir> <tmp_dir> <gatk_path> <scripts_dir>"
  exit 1
fi

# Extend PATH to include Miniconda3 binaries
export PATH="${MINICONDA_PATH}:$PATH"

# Set working directory and exit if it does not exist
cd "${WORK_DIR}" || exit 1

# Mark Duplicates
echo "Starting MarkDuplicates..."
find . -name "*_paired.bam" -print0 | parallel -j 32 -0 "java -jar ${GATK_PATH}/gatk.jar MarkDuplicates --CREATE_INDEX false --TMP_DIR ${TMP_DIR} -I {} -M {.}.metrics -O {.}_md.bam"

# Add Read Groups
echo "Adding Read Groups..."
find . -name "*_paired_md.bam" -print0 | parallel -j 32 -0 "bash ${SCRIPTS_DIR}/add_read_groups_parallel.sh {}"

echo "Steps completed."
