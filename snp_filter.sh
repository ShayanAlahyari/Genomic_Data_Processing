#!/bin/bash

#$ -N SNP-filter
#$ -S /bin/bash
#$ -pe smp 32

# Command-line Arguments
GATK_PATH="$1"
REFERENCE_GENOME="$2"
INPUT_VCF="$3"
OUTPUT_VCF="$4"
OUTPUT_TABLE="$5"

# Exit if any required arguments are missing
if [ -z "$GATK_PATH" ] || [ -z "$REFERENCE_GENOME" ] || [ -z "$INPUT_VCF" ] || [ -z "$OUTPUT_VCF" ] || [ -z "$OUTPUT_TABLE" ]; then
  echo "Error: Missing arguments."
  echo "Usage: $0 <gatk_path> <reference_genome> <input_vcf> <output_vcf> <output_table>"
  exit 1
fi

# Select variants, only SNP will be analyzed
$GATK_PATH --java-options "-Xms60G -Xmx120G" SelectVariants \
    -R $REFERENCE_GENOME \
    -V $INPUT_VCF \
    --select-type-to-include SNP \
    -O $OUTPUT_VCF &&

# Check the distribution of parameters
$GATK_PATH VariantsToTable \
    -V $OUTPUT_VCF \
    -F CHROM \
    -F POS \
    -F QD \
    -F QUAL \
    -F SOR \
    -F FS \
    -F MQ \
    -F MQRankSum \
    -F ReadPosRankSum \
    -O $OUTPUT_TABLE &&

# Apply hard filtering on the selected SNP variants
$GATK_PATH VariantFiltration \
    -V $OUTPUT_VCF \
    -filter "QD < 2.0" --filter-name "QD2" \
    -filter "QUAL < 30.0" --filter-name "QUAL30" \
    -filter "FS > 60.0" --filter-name "FS60" \
    -filter "MQ < 40.0" --filter-name "MQ40" \
    -filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
    -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
    -O $OUTPUT_VCF
