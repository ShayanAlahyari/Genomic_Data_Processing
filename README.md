# Genomic Data Processing for Machine Learning

![GitHub repo size](https://img.shields.io/github/repo-size/ShayanAlahyari/Genomic_Data_Processing)
![GitHub contributors](https://img.shields.io/github/contributors/ShayanAlahyari/Genomic_Data_Processing)
![GitHub stars](https://img.shields.io/github/stars/ShayanAlahyari/Genomic_Data_Processing?style=social)
![GitHub forks](https://img.shields.io/github/forks/ShayanAlahyari/Genomic_Data_Processing?style=social)
![GitHub last commit](https://img.shields.io/github/last-commit/ShayanAlahyari/Genomic_Data_Processing)
![GitHub license](https://img.shields.io/github/license/ShayanAlahyari/Genomic_Data_Processing)

## 👋 Hi there, I'm Shayan Alahyari!

I am a Master of Science student at Western University, supervised by Professor Mike Domaratzki. This repository contains a collection of shell scripts used for processing large genomic data and preparing it for machine learning models. This project showcases various steps in genomic data processing, including BAM indexing, filtering, base recalibration, variant calling, and SNP filtering.

## 🚀 Project Overview

This project was part of my summer research at Western University focusing on processing large genomic datasets. The data used in this project is private and cannot be shared, but the scripts demonstrate the workflow and processing steps involved.

### Key Steps:
1. **BAM Indexing and Filtering**: Index and filter BAM files for quality control.
2. **Mark Duplicates and Add Read Groups**: Process BAM files to mark duplicates and add read groups.
3. **Base Recalibration**: Perform base quality score recalibration.
4. **Haplotype Calling**: Call variants using GATK HaplotypeCaller.
5. **GenomicsDB Import**: Import data into GenomicsDB for efficient querying.
6. **GenotypeGVCFs**: Genotype the GVCFs.
7. **SNP Filtering**: Select and filter SNP variants.

## 🛠️ Scripts

### 1. `index_and_filter_bam.sh`
Indexes BAM files and filters for paired reads with quality > 1.

### 2. `mark_duplicates_and_add_read_groups.sh`
Marks duplicates in BAM files and adds read groups.

### 3. `base_recalibration_and_apply_bqsr.sh`
Performs base quality score recalibration and applies BQSR.

### 4. `haplotype_caller.sh`
Calls variants using GATK HaplotypeCaller.

### 5. `genomicsdb_import.sh`
Imports data into GenomicsDB for efficient querying.

### 6. `genotype_gvcfs.sh`
Genotypes the GVCFs.

### 7. `snp_filter.sh`
Selects and filters SNP variants.

## 🖥️ Usage

To use these scripts, you need to provide the required arguments. Below are examples of how to run each script.

### Example Usage

```bash
./scripts/index_and_filter_bam.sh /path/to/miniconda /path/to/workdir
./scripts/mark_duplicates_and_add_read_groups.sh /path/to/miniconda /path/to/workdir /path/to/tmpdir /path/to/gatk /path/to/scripts
./scripts/base_recalibration_and_apply_bqsr.sh /path/to/miniconda /path/to/workdir /path/to/gatk /path/to/scripts /path/to/reference_genome /path/to/known_sites /path/to/tmpdir
./scripts/haplotype_caller.sh /path/to/conda /path/to/gatk /path/to/reference_genome /path/to/original_bam /path/to/output_dir
./scripts/genomicsdb_import.sh /path/to/gatk /path/to/sample_map /path/to/workspace /path/to/tmpdir /path/to/reference_genome
./scripts/genotype_gvcfs.sh /path/to/gatk /path/to/reference_genome /path/to/tmpdir
./scripts/snp_filter.sh /path/to/gatk /path/to/reference_genome /path/to/input_vcf /path/to/output_vcf /path/to/output_table
