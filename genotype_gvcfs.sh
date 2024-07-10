#!/bin/bash

#$ -N GenotypeGVCFs
#$ -S /bin/bash
#$ -pe smp 32

# Command-line Arguments
GATK_PATH="$1"
REFERENCE_GENOME="$2"
TMP_DIR="$3"

# Exit if any required arguments are missing
if [ -z "$GATK_PATH" ] || [ -z "$REFERENCE_GENOME" ] || [ -z "$TMP_DIR" ]; then
  echo "Error: Missing arguments."
  echo "Usage: $0 <gatk_path> <reference_genome> <tmp_dir>"
  exit 1
fi

# Array of chromosomes or genomic intervals
declare -a arr=("Chr1A" "Chr1B" "Chr1D" "Chr2A" "Chr2B" "Chr2D" "Chr3A" "Chr3B" "Chr3D" "Chr4A" "Chr4B" "Chr4D" "Chr5A" "Chr5B" "Chr5D" "Chr6A" "Chr6B" "Chr6D" "Chr7A" "Chr7B" "Chr7D" "ChrUnknown")

# Loop over the array of chromosomes
for chr in "${arr[@]}"
do
    $GATK_PATH --java-options "-Xms60G -Xmx120G" GenotypeGVCFs \
        -R $REFERENCE_GENOME \
        --intervals "$chr" \
        -V gendb:///data/GenomicsDB_modified/GenomicsDB_"$chr" \
        --tmp-dir $TMP_DIR \
        -O /data/GenomicsDB_modified/step8/Backcross_pop_CarC52_"$chr".vcf &
    
    if (( $(jobs -r | wc -l) >= 32 )); then
        wait -n  # Wait for any job to finish before continuing the loop
    fi
done

# Wait for all background processes to finish
wait
