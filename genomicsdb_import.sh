#!/bin/bash

#$ -N GATK_step_7
#$ -S /bin/bash
#$ -pe smp 32

# Command-line Arguments
GATK_PATH="$1"
SAMPLE_MAP="$2"
WORKSPACE_BASE_PATH="$3"
TMP_DIR="$4"
REFERENCE_GENOME="$5"

# Exit if any required arguments are missing
if [ -z "$GATK_PATH" ] || [ -z "$SAMPLE_MAP" ] || [ -z "$WORKSPACE_BASE_PATH" ] || [ -z "$TMP_DIR" ] || [ -z "$REFERENCE_GENOME" ]; then
  echo "Error: Missing arguments."
  echo "Usage: $0 <gatk_path> <sample_map> <workspace_base_path> <tmp_dir> <reference_genome>"
  exit 1
fi

export JAVA_OPTS="-Xms60G -Xmx120G"

# Array of chromosomes or genomic intervals
declare -a arr=("Chr1A" "Chr1B" "Chr1D" "Chr2A" "Chr2B" "Chr2D" "Chr3A" "Chr3B" "Chr3D" "Chr4A" "Chr4B" "Chr4D" "Chr5A" "Chr5B" "Chr5D" "Chr6A" "Chr6B" "Chr6D" "Chr7A" "Chr7B" "Chr7D" "ChrUnknown")

# Loop over the array of chromosomes
for chr in "${arr[@]}"
do
    echo "Importing data for $chr"
    $GATK_PATH GenomicsDBImport \
        --java-options "$JAVA_OPTS" \
        --sample-name-map "$SAMPLE_MAP" \
        --genomicsdb-workspace-path "$WORKSPACE_BASE_PATH/GenomicsDB_$chr" \
        --tmp-dir "$TMP_DIR" \
        --intervals "$chr" \
        --reader-threads 8 &
    
    if (( $(jobs -r | wc -l) >= 4 )); then
        wait -n  # Wait for any job to finish before continuing the loop
    fi
done

# Wait for all background processes to finish
wait
echo "GenomicsDB import completed for all regions."
